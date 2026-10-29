using { cockpit } from '../db/schema';

service ApprovalService {
  entity OrderApprovals as projection on cockpit.OrderApprovals;
}