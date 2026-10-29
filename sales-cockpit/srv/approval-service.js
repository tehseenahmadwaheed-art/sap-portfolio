const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  // Connect to the remote S/4HANA API defined in package.json (cds.requires)
  const s4 = await cds.connect.to('API_SALES_ORDER_SRV');
  const { SalesOrders } = this.entities;

  // Forward READs on SalesOrders to S/4HANA; the API key comes from an env variable, never from git
  this.on('READ', SalesOrders, req =>
    s4.send({ query: req.query, headers: { APIKey: process.env.SAP_API_KEY } })
  );
});