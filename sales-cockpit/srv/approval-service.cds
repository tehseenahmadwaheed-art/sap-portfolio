using { cockpit } from '../db/schema';

@requires: 'authenticated-user'
service ApprovalService {
  @restrict: [
    { grant: 'READ', to: 'authenticated-user' },
    { grant: ['CREATE','UPDATE'], to: 'Approver' }
  ]
  entity OrderApprovals as projection on cockpit.OrderApprovals;
}