   using ApprovalService from './approval-service';

   annotate ApprovalService.OrderApprovals with @(
     UI.LineItem: [
       { Value: salesOrder, Label: 'Sales Order' },
       { Value: status,     Label: 'Status' },
       { Value: approver,   Label: 'Approver' },
       { Value: comment,    Label: 'Comment' }
     ]
   );