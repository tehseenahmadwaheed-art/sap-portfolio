using ApprovalService from './approval-service';

annotate ApprovalService.OrderApprovals with @(
  UI.HeaderInfo: {
    TypeName      : 'Order Approval',
    TypeNamePlural: 'Order Approvals',
    Title         : { Value: salesOrder }
  },
  UI.SelectionFields: [ salesOrder, status, approver ],
  UI.LineItem: [
    { Value: salesOrder, Label: 'Sales Order' },
    { Value: customer,   Label: 'Customer' },
    { Value: netAmount,  Label: 'Net Amount' },
    { Value: status,     Label: 'Status' },
    { Value: approver,   Label: 'Approver' },
    { Value: comment,    Label: 'Comment' }
  ],
  UI.FieldGroup #Main: { Data: [
    { Value: customer,   Label: 'Customer (from S/4HANA)' },
    { Value: netAmount,  Label: 'Net Amount (from S/4HANA)' },
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
annotate ApprovalService.OrderApprovals with @odata.draft.enabled @Capabilities.DeleteRestrictions.Deletable: false;

// Show Net Amount as money in its own currency (52.65 EUR, not 52.650)
annotate ApprovalService.OrderApprovals with { netAmount @Measures.ISOCurrency: currency; };

// Proper labels for filters and fields (instead of raw names like salesOrder)
annotate ApprovalService.OrderApprovals with {
  salesOrder @title: 'Sales Order';
  status     @title: 'Status';
  approver   @title: 'Approver';
  comment    @title: 'Comment';
  customer   @title: 'Customer';
  netAmount  @title: 'Net Amount';
  currency   @title: 'Currency';
};
