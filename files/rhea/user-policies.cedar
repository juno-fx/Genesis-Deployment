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
when { context.url like "*/genesis/workload*" || context.url like "*/workloads*" || context.url like "*/genesis/docs*" };

permit (
  principal in Group::"titan",
  action,
  resource
)
when { context.url like "*/usermanagement*" || context.url like "*/titan*" };

permit (
  principal in Group::"terra",
  action,
  resource
)
when { context.url like "*/appstore*" || context.url like "*/terra*" };

// Development access
permit (
  principal in Group::"titan",
  action,
  resource
)
when { context.url like "*/development*" };

permit (
  principal in Group::"terra",
  action,
  resource
)
when { context.url like "*/development*" };

permit (
  principal in Group::"kuiper",
  action,
  resource
)
when { context.url like "*/development*" };
