namespace cockpit;
using { cuid, managed } from '@sap/cds/common';

entity OrderApprovals : cuid, managed {
  salesOrder : String(10) @Core.Immutable;   // set once when created, then locked
  @assert.range  // only these 3 values allowed
  status     : String(20) enum { Pending; Approved; Rejected } default 'Pending';
  approver   : String(100) @readonly;         // filled in automatically from the logged-in user
  comment    : String(500);
}
