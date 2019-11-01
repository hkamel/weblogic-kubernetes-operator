# Copyright (c) 2018, 2019, Oracle Corporation and/or its affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

{{- define "operator.clusterRoleBindingDiscovery" }}
---
apiVersion: "rbac.authorization.k8s.io/v1"
{{- if .dedicated }}
kind: "RoleBinding"
{{- else }}
kind: "ClusterRoleBinding"
{{- end }}
metadata:
  labels:
    weblogic.operatorName: {{ .Release.Namespace | quote }}
    weblogic.resourceVersion: "operator-v2"
  {{- if .dedicated }}
  name: "weblogic-operator-rolebinding-discovery"
  namespace: {{ .Release.Namespace | quote }}
  {{- else }}
  name: {{ list .Release.Namespace "weblogic-operator-clusterrolebinding-discovery" | join "-" | quote }}
  {{- end }}
roleRef:
  apiGroup: "rbac.authorization.k8s.io"
  kind: "ClusterRole"
  name: "system:discovery"
subjects:
- kind: "ServiceAccount"
  apiGroup: ""
  name: {{ .serviceAccount | quote }}
  namespace: {{ .Release.Namespace | quote }}
{{- end }}
