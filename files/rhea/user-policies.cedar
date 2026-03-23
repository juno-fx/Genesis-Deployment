// Admins can do anything they want
permit (
  principal in Group::"admin",
  action,
  resource
);

// These are wide open
permit (principal, action, resource)
when { context.url like "*/projects/" || context.url like "*/home/" };

permit (
  principal in Group::"kuiper",
  action,
  resource
)
when { context.url.contains("/workloads") };

permit (
  principal in Group::"kuiper",
  action,
  resource
)
when
{
  context.url.contains("/genesis") &&
  !(context.url.contains("/genesis/ansible")) &&
  !(context.url.contains("/genesis/node/provision"))
};

permit (
  principal in Group::"titan",
  action,
  resource
)
when
{ context.url.contains("/usermanagement") || context.url.contains("/titan") };

permit (
  principal in Group::"terra",
  action,
  resource
)
when { context.url.contains("/appstore") || context.url.contains("/terra") };

// Development access
permit (
  principal in Group::"titan",
  action,
  resource
)
when { context.url.contains("/development") };

permit (
  principal in Group::"terra",
  action,
  resource
)
when { context.url.contains("/development") };

permit (
  principal in Group::"kuiper",
  action,
  resource
)
when { context.url.contains("/development") };
