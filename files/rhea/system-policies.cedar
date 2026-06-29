permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Values.namespace }}::Service::"titan"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "metrics-gatherer" ||
  principal.serviceAccountName == "terra"
};

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Values.namespace }}::Service::"terra"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "metrics-gatherer" ||
  principal.serviceAccountName == "terra"
};

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Values.namespace }}::Service::"genesis"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "metrics-gatherer" ||
  principal.serviceAccountName == "terra"
};

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Values.namespace }}::Service::"metrics-gatherer"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "metrics-gatherer" ||
  principal.serviceAccountName == "terra"
};
