using { cockpit } from '../db/schema';
using { API_SALES_ORDER_SRV as s4 } from './external/API_SALES_ORDER_SRV';

@requires: 'authenticated-user'
service ApprovalService {
  @restrict: [
    { grant: 'READ', to: 'authenticated-user' },
    { grant: ['CREATE','UPDATE'], to: 'Approver' }
  ]
  entity OrderApprovals as projection on cockpit.OrderApprovals;

  // Live S/4HANA sales orders, read-only, fetched from the SAP API sandbox
  @readonly
  entity SalesOrders as projection on s4.A_SalesOrder {
    key SalesOrder, SalesOrderType, SoldToParty, SalesOrganization,
        CreationDate, TotalNetAmount, TransactionCurrency, OverallSDProcessStatus
  };
}