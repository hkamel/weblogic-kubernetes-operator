# Copyright (c) 2018, 2019, Oracle Corporation and/or its affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

{{- define "operator.operatorClusterRoleNamespace" }}
---
kind: "ClusterRole"
apiVersion: "rbac.authorization.k8s.io/v1"
metadata:
  name: {{ list .Release.Namespace "weblogic-operator-clusterrole-namespace" | join "-" | quote }}
  labels:
    weblogic.resourceVersion: "operator-v2"
    weblogic.operatorName: {{ .Release.Namespace | quote }}
rules:
- apiGroups: [""]
  resources: ["services", "configmaps", "pods", "events"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete", "deletecollection"]
- apiGroups: [""]
  resources: ["secrets", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete", "deletecollection"]
{{- end }}
