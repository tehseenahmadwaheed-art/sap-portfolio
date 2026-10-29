namespace cockpit;
using { cuid, managed } from '@sap/cds/common';

entity OrderApprovals : cuid, managed {
  salesOrder : String(10);
  status     : String(20) default 'Pending';
  approver   : String(100);
  comment    : String(500);
}
