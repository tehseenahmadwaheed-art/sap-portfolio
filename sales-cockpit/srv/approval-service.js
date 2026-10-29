const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  // Connect to the remote S/4HANA API defined in package.json (cds.requires)
  const s4 = await cds.connect.to('API_SALES_ORDER_SRV');
  const { SalesOrders, OrderApprovals } = this.entities;
  // API key: on the laptop from env var SAP_API_KEY; on BTP from the user-provided service 'sales-cockpit-s4-key'
  const fromBtp = () => {
    try {
      const ups = JSON.parse(process.env.VCAP_SERVICES || '{}')['user-provided'] || [];
      return (ups.find(s => s.name === 'sales-cockpit-s4-key') || {}).credentials?.APIKey;
    } catch { return undefined; }
  };
  const key = process.env.SAP_API_KEY || fromBtp();
  if (!key) cds.log('s4').warn('No SAP API key found: S/4HANA details will be empty');
  const apiKey = () => ({ APIKey: key });

  // 1) SalesOrders list: forward every READ straight to S/4HANA
  this.on('READ', SalesOrders, req => s4.send({ query: req.query, headers: apiKey() }));

  // 2a) We need the order number to match with S/4HANA, so always read it, even if the screen didn't ask for it
  this.before('READ', OrderApprovals, req => {
    const cols = req.query.SELECT.columns;
    if (cols && !cols.some(c => c === '*' || (c.ref && c.ref[0] === 'salesOrder'))) cols.push({ ref: ['salesOrder'] });
  });

  // 2) Approvals: after reading our own notes, fetch the matching orders from S/4HANA in ONE call
  //    and fill in customer + amount by matching the sales order number
  this.after('READ', OrderApprovals, async rows => {
    const list = Array.isArray(rows) ? rows : rows ? [rows] : [];
    const ids = [...new Set(list.map(r => r.salesOrder).filter(Boolean))];
    if (!ids.length) return;
    try {
      const orders = await s4.send({
        query: SELECT.from(s4.entities.A_SalesOrder)
          .columns('SalesOrder', 'SoldToParty', 'TotalNetAmount', 'TransactionCurrency')
          .where({ SalesOrder: { in: ids } }),
        headers: apiKey()
      });
      const byId = new Map(orders.map(o => [o.SalesOrder, o]));
      for (const r of list) {
        const o = byId.get(r.salesOrder);
        if (o) { r.customer = o.SoldToParty; r.netAmount = o.TotalNetAmount; r.currency = o.TransactionCurrency; }
      }
    } catch (e) {
      // If S/4HANA is down or the key is missing, still show our approvals (just without SAP details)
      cds.log('s4').warn('Could not load sales order details:', e.message);
    }
  });
});