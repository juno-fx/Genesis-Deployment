permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == argocd::Service::"titan"
);

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == argocd::Service::"terra"
);

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == argocd::Service::"genesis"
);
