using ApprovalService from './approval-service';

annotate ApprovalService.OrderApprovals with @(
  UI.HeaderInfo: {
    TypeName      : 'Order Approval',
    TypeNamePlural: 'Order Approvals',
    Title         : { Value: salesOrder },
    Description   : { Value: status }
  },
  UI.SelectionFields: [ salesOrder, status, approver ],
  UI.LineItem: [
    { Value: salesOrder, Label: 'Sales Order' },
    { Value: status,     Label: 'Status' },
    { Value: approver,   Label: 'Approver' },
    { Value: comment,    Label: 'Comment' }
  ],
  UI.FieldGroup #Main: { Data: [
    { Value: salesOrder, Label: 'Sales Order' },
    { Value: status,     Label: 'Status' },
    { Value: approver,   Label: 'Approver' },
    { Value: comment,    Label: 'Comment' }
  ]},
  UI.FieldGroup #Admin: { Data: [
    { Value: createdBy }, { Value: createdAt }, { Value: modifiedBy }, { Value: modifiedAt }
  ]},
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'Approval', Target: '@UI.FieldGroup#Main' },
    { $Type: 'UI.ReferenceFacet', Label: 'Admin',    Target: '@UI.FieldGroup#Admin' }
  ]
);