# Copyright (c) 2019, Oracle Corporation and/or its affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

{{- define "operator.operatorCustomResourceDefinitionValidation" }}
openAPIV3Schema:
  properties:
    spec:
      type: object
      description: DomainSpec is a description of a domain.
      properties:
        serverStartState:
          type: string
          description: The state in which the server is to be started. Use ADMIN if
            server should start in the admin state. Defaults to RUNNING.
          enum:
          - RUNNING
          - ADMIN
        image:
          type: string
          description: The WebLogic Docker image; required when domainHomeInImage
            is true; otherwise, defaults to container-registry.oracle.com/middleware/weblogic:12.2.1.3.
        imagePullPolicy:
          type: string
          description: The image pull policy for the WebLogic Docker image. Legal
            values are Always, Never and IfNotPresent. Defaults to Always if image
            ends in :latest, IfNotPresent otherwise.
          enum:
          - Always
          - Never
          - IfNotPresent
        replicas:
          type: number
          description: The number of managed servers to run in any cluster that does
            not specify a replica count.
          minimum: 0.0
        configOverrideSecrets:
          type: array
          description: A list of names of the secrets for optional WebLogic configuration
            overrides.
          items:
            type: string
        imagePullSecrets:
          type: array
          description: A list of image pull secrets for the WebLogic Docker image.
          items:
            type: object
            properties:
              name:
                type: string
        domainHomeInImage:
          type: boolean
          description: True if this domain's home is defined in the Docker image for
            the domain. Defaults to true.
        domainUID:
          type: string
          description: Domain unique identifier. Must be unique across the Kubernetes
            cluster. Not required. Defaults to the value of metadata.name.
          pattern: ^[a-z0-9-.]{1,253}$
        experimental:
          type: object
          description: Experimental feature configurations.
          properties:
            istio:
              type: object
              description: Istio service mesh integration configuration.
              properties:
                readinessPort:
                  type: number
                  description: The WebLogic readiness port for Istio. Defaults to
                    8888. Not required.
                enabled:
                  type: boolean
                  description: True, if this domain is deployed under an Istio service
                    mesh. Defaults to true when the 'istio' element is included. Not
                    required.
        serverStartPolicy:
          type: string
          description: The strategy for deciding whether to start a server. Legal
            values are ADMIN_ONLY, NEVER, or IF_NEEDED.
          enum:
          - NEVER
          - IF_NEEDED
          - ADMIN_ONLY
        restartVersion:
          type: string
          description: If present, every time this value is updated the operator will
            restart the required servers.
        dataHome:
          type: string
          description: 'An optional, in-pod location for data storage of default and
            custom file stores. If dataHome is not specified or its value is either
            not set or empty (e.g. dataHome: "") then the data storage directories
            are determined from the WebLogic domain home configuration.'
        configOverrides:
          type: string
          description: The name of the config map for optional WebLogic configuration
            overrides.
        serverService:
          type: object
          description: Customization affecting ClusterIP Kubernetes services for WebLogic
            Server instances.
          properties:
            precreateService:
              type: boolean
              description: If true, operator will create server services even for
                server instances without running pods.
            annotations:
              type: object
              description: The annotations to be attached to generated resources.
              properties: {}
            labels:
              type: object
              description: The labels to be attached to generated resources. The label
                names must not start with 'weblogic.'.
              properties: {}
        domainHome:
          type: string
          description: The folder for the WebLogic Domain. Not required. Defaults
            to /shared/domains/domains/domainUID if domainHomeInImage is false. Defaults
            to /u01/oracle/user_projects/domains/ if domainHomeInImage is true.
        logHomeEnabled:
          type: boolean
          description: 'Specified whether the log home folder is enabled. Not required.
            Defaults to true if domainHomeInImage is false. Defaults to false if domainHomeInImage
            is true. '
        webLogicCredentialsSecret:
          type: object
          description: The name of a pre-created Kubernetes secret, in the domain's
            namespace, that holds the username and password needed to boot WebLogic
            Server under the 'username' and 'password' fields.
          properties:
            name:
              type: string
            namespace:
              type: string
        adminServer:
          type: object
          description: Configuration for the Administration Server.
          properties:
            serverStartState:
              type: string
              description: The state in which the server is to be started. Use ADMIN
                if server should start in the admin state. Defaults to RUNNING.
              enum:
              - RUNNING
              - ADMIN
            serverService:
              type: object
              description: Customization affecting ClusterIP Kubernetes services for
                WebLogic Server instances.
              properties:
                precreateService:
                  type: boolean
                  description: If true, operator will create server services even
                    for server instances without running pods.
                annotations:
                  type: object
                  description: The annotations to be attached to generated resources.
                  properties: {}
                labels:
                  type: object
                  description: The labels to be attached to generated resources. The
                    label names must not start with 'weblogic.'.
                  properties: {}
            serverPod:
              type: object
              description: Configuration affecting server pods.
              properties:
                nodeName:
                  type: string
                  description: NodeName is a request to schedule this pod onto a specific
                    node. If it is non-empty, the scheduler simply schedules this
                    pod onto that node, assuming that it fits resource requirements.
                livenessProbe:
                  type: object
                  description: Settings for the liveness probe associated with a server.
                  properties:
                    periodSeconds:
                      type: number
                      description: The number of seconds between checks.
                    timeoutSeconds:
                      type: number
                      description: The number of seconds with no response that indicates
                        a failure.
                    initialDelaySeconds:
                      type: number
                      description: The number of seconds before the first check is
                        performed.
                readinessGates:
                  type: array
                  description: 'If specified, all readiness gates will be evaluated
                    for pod readiness. A pod is ready when all its containers are
                    ready AND all conditions specified in the readiness gates have
                    status equal to "True" More info: https://github.com/kubernetes/community/blob/master/keps/sig-network/0007-pod-ready%2B%2B.md'
                  items:
                    type: object
                    properties:
                      conditionType:
                        type: string
                serviceAccountName:
                  type: string
                  description: Name of the ServiceAccount to be used to run this pod.
                    If it is not set, default ServiceAccount will be used. The ServiceAccount
                    has to exist at the time the pod is created.
                podSecurityContext:
                  type: object
                  description: Pod-level security attributes.
                  properties:
                    runAsUser:
                      type: number
                    seLinuxOptions:
                      type: object
                      properties:
                        role:
                          type: string
                        level:
                          type: string
                        type:
                          type: string
                        user:
                          type: string
                    fsGroup:
                      type: number
                    supplementalGroups:
                      type: array
                      items:
                        type: number
                    runAsGroup:
                      type: number
                    runAsNonRoot:
                      type: boolean
                    sysctls:
                      type: array
                      items:
                        type: object
                        properties:
                          name:
                            type: string
                          value:
                            type: string
                priorityClassName:
                  type: string
                  description: If specified, indicates the pod's priority. "system-node-critical"
                    and "system-cluster-critical" are two special keywords which indicate
                    the highest priorities with the former being the highest priority.
                    Any other name must be defined by creating a PriorityClass object
                    with that name. If not specified, the pod priority will be default
                    or zero if there is no default.
                volumes:
                  type: array
                  description: Additional volumes to be created in the server pod.
                  items:
                    type: object
                    properties:
                      quobyte:
                        type: object
                        properties:
                          volume:
                            type: string
                          registry:
                            type: string
                          readOnly:
                            type: boolean
                          user:
                            type: string
                          tenant:
                            type: string
                          group:
                            type: string
                      azureFile:
                        type: object
                        properties:
                          secretName:
                            type: string
                          readOnly:
                            type: boolean
                          shareName:
                            type: string
                      flexVolume:
                        type: object
                        properties:
                          driver:
                            type: string
                          options:
                            type: object
                            properties: {}
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                      secret:
                        type: object
                        properties:
                          secretName:
                            type: string
                          defaultMode:
                            type: number
                          optional:
                            type: boolean
                          items:
                            type: array
                            items:
                              type: object
                              properties:
                                mode:
                                  type: number
                                path:
                                  type: string
                                key:
                                  type: string
                      projected:
                        type: object
                        properties:
                          sources:
                            type: array
                            items:
                              type: object
                              properties:
                                downwardAPI:
                                  type: object
                                  properties:
                                    items:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          mode:
                                            type: number
                                          path:
                                            type: string
                                          resourceFieldRef:
                                            type: object
                                            properties:
                                              divisor:
                                                type: string
                                              resource:
                                                type: string
                                              containerName:
                                                type: string
                                          fieldRef:
                                            type: object
                                            properties:
                                              apiVersion:
                                                type: string
                                              fieldPath:
                                                type: string
                                configMap:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    items:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          mode:
                                            type: number
                                          path:
                                            type: string
                                          key:
                                            type: string
                                secret:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    items:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          mode:
                                            type: number
                                          path:
                                            type: string
                                          key:
                                            type: string
                                serviceAccountToken:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    audience:
                                      type: string
                                    expirationSeconds:
                                      type: number
                          defaultMode:
                            type: number
                      cephfs:
                        type: object
                        properties:
                          path:
                            type: string
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          secretFile:
                            type: string
                          readOnly:
                            type: boolean
                          user:
                            type: string
                          monitors:
                            type: array
                            items:
                              type: string
                      scaleIO:
                        type: object
                        properties:
                          system:
                            type: string
                          protectionDomain:
                            type: string
                          sslEnabled:
                            type: boolean
                          storageMode:
                            type: string
                          volumeName:
                            type: string
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                          storagePool:
                            type: string
                          gateway:
                            type: string
                      emptyDir:
                        type: object
                        properties:
                          sizeLimit:
                            type: string
                          medium:
                            type: string
                      glusterfs:
                        type: object
                        properties:
                          path:
                            type: string
                          endpoints:
                            type: string
                          readOnly:
                            type: boolean
                      gcePersistentDisk:
                        type: object
                        properties:
                          partition:
                            type: number
                          readOnly:
                            type: boolean
                          pdName:
                            type: string
                          fsType:
                            type: string
                      photonPersistentDisk:
                        type: object
                        properties:
                          pdID:
                            type: string
                          fsType:
                            type: string
                      azureDisk:
                        type: object
                        properties:
                          diskName:
                            type: string
                          kind:
                            type: string
                          readOnly:
                            type: boolean
                          cachingMode:
                            type: string
                          diskURI:
                            type: string
                          fsType:
                            type: string
                      cinder:
                        type: object
                        properties:
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          volumeID:
                            type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                      downwardAPI:
                        type: object
                        properties:
                          defaultMode:
                            type: number
                          items:
                            type: array
                            items:
                              type: object
                              properties:
                                mode:
                                  type: number
                                path:
                                  type: string
                                resourceFieldRef:
                                  type: object
                                  properties:
                                    divisor:
                                      type: string
                                    resource:
                                      type: string
                                    containerName:
                                      type: string
                                fieldRef:
                                  type: object
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                      awsElasticBlockStore:
                        type: object
                        properties:
                          partition:
                            type: number
                          volumeID:
                            type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                      flocker:
                        type: object
                        properties:
                          datasetName:
                            type: string
                          datasetUUID:
                            type: string
                      iscsi:
                        type: object
                        properties:
                          chapAuthSession:
                            type: boolean
                          iscsiInterface:
                            type: string
                          lun:
                            type: number
                          chapAuthDiscovery:
                            type: boolean
                          iqn:
                            type: string
                          portals:
                            type: array
                            items:
                              type: string
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          initiatorName:
                            type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                          targetPortal:
                            type: string
                      rbd:
                        type: object
                        properties:
                          image:
                            type: string
                          pool:
                            type: string
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                          keyring:
                            type: string
                          user:
                            type: string
                          monitors:
                            type: array
                            items:
                              type: string
                      configMap:
                        type: object
                        properties:
                          defaultMode:
                            type: number
                          name:
                            type: string
                          optional:
                            type: boolean
                          items:
                            type: array
                            items:
                              type: object
                              properties:
                                mode:
                                  type: number
                                path:
                                  type: string
                                key:
                                  type: string
                      storageos:
                        type: object
                        properties:
                          volumeNamespace:
                            type: string
                          volumeName:
                            type: string
                          secretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                      csi:
                        type: object
                        properties:
                          driver:
                            type: string
                          nodePublishSecretRef:
                            type: object
                            properties:
                              name:
                                type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                          volumeAttributes:
                            type: object
                            properties: {}
                      name:
                        type: string
                      nfs:
                        type: object
                        properties:
                          path:
                            type: string
                          server:
                            type: string
                          readOnly:
                            type: boolean
                      persistentVolumeClaim:
                        type: object
                        properties:
                          claimName:
                            type: string
                          readOnly:
                            type: boolean
                      gitRepo:
                        type: object
                        properties:
                          repository:
                            type: string
                          directory:
                            type: string
                          revision:
                            type: string
                      portworxVolume:
                        type: object
                        properties:
                          volumeID:
                            type: string
                          readOnly:
                            type: boolean
                          fsType:
                            type: string
                      vsphereVolume:
                        type: object
                        properties:
                          storagePolicyName:
                            type: string
                          storagePolicyID:
                            type: string
                          volumePath:
                            type: string
                          fsType:
                            type: string
                      fc:
                        type: object
                        properties:
                          lun:
                            type: number
                          targetWWNs:
                            type: array
                            items:
                              type: string
                          readOnly:
                            type: boolean
                          wwids:
                            type: array
                            items:
                              type: string
                          fsType:
                            type: string
                      hostPath:
                        type: object
                        properties:
                          path:
                            type: string
                          type:
                            type: string
                resources:
                  type: object
                  description: Memory and CPU minimum requirements and limits for
                    the server.
                  properties:
                    requests:
                      type: object
                      properties: {}
                    limits:
                      type: object
                      properties: {}
                annotations:
                  type: object
                  description: The annotations to be attached to generated resources.
                  properties: {}
                env:
                  type: array
                  description: A list of environment variables to add to a server.
                  items:
                    type: object
                    properties:
                      name:
                        type: string
                      value:
                        type: string
                      valueFrom:
                        type: object
                        properties:
                          secretKeyRef:
                            type: object
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                              key:
                                type: string
                          resourceFieldRef:
                            type: object
                            properties:
                              divisor:
                                type: string
                              resource:
                                type: string
                              containerName:
                                type: string
                          configMapKeyRef:
                            type: object
                            properties:
                              name:
                                type: string
                              optional:
                                type: boolean
                              key:
                                type: string
                          fieldRef:
                            type: object
                            properties:
                              apiVersion:
                                type: string
                              fieldPath:
                                type: string
                restartPolicy:
                  type: string
                  description: 'Restart policy for all containers within the pod.
                    One of Always, OnFailure, Never. Default to Always. More info:
                    https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy'
                nodeSelector:
                  type: object
                  description: Selector which must match a node's labels for the pod
                    to be scheduled on that node.
                  properties: {}
                volumeMounts:
                  type: array
                  description: Additional volume mounts for the server pod.
                  items:
                    type: object
                    properties:
                      mountPath:
                        type: string
                      mountPropagation:
                        type: string
                      name:
                        type: string
                      readOnly:
                        type: boolean
                      subPath:
                        type: string
                      subPathExpr:
                        type: string
                labels:
                  type: object
                  description: The labels to be attached to generated resources. The
                    label names must not start with 'weblogic.'.
                  properties: {}
                runtimeClassName:
                  type: string
                  description: 'RuntimeClassName refers to a RuntimeClass object in
                    the node.k8s.io group, which should be used to run this pod.  If
                    no RuntimeClass resource matches the named class, the pod will
                    not be run. If unset or empty, the "legacy" RuntimeClass will
                    be used, which is an implicit class with an empty definition that
                    uses the default runtime handler. More info: https://github.com/kubernetes/community/blob/master/keps/sig-node/0014-runtime-class.md
                    This is an alpha feature and may change in the future.'
                tolerations:
                  type: array
                  description: If specified, the pod's tolerations.
                  items:
                    type: object
                    properties:
                      effect:
                        type: string
                      tolerationSeconds:
                        type: number
                      value:
                        type: string
                      key:
                        type: string
                      operator:
                        type: string
                readinessProbe:
                  type: object
                  description: Settings for the readiness probe associated with a
                    server.
                  properties:
                    periodSeconds:
                      type: number
                      description: The number of seconds between checks.
                    timeoutSeconds:
                      type: number
                      description: The number of seconds with no response that indicates
                        a failure.
                    initialDelaySeconds:
                      type: number
                      description: The number of seconds before the first check is
                        performed.
                containers:
                  type: array
                  description: Additional containers to be included in the server
                    pod.
                  items:
                    type: object
                    properties:
                      volumeDevices:
                        type: array
                        items:
                          type: object
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      livenessProbe:
                        type: object
                        properties:
                          failureThreshold:
                            type: number
                          periodSeconds:
                            type: number
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          timeoutSeconds:
                            type: number
                          successThreshold:
                            type: number
                          initialDelaySeconds:
                            type: number
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      stdin:
                        type: boolean
                      terminationMessagePolicy:
                        type: string
                      terminationMessagePath:
                        type: string
                      workingDir:
                        type: string
                      resources:
                        type: object
                        properties:
                          requests:
                            type: object
                            properties: {}
                          limits:
                            type: object
                            properties: {}
                      securityContext:
                        type: object
                        properties:
                          privileged:
                            type: boolean
                          runAsUser:
                            type: number
                          capabilities:
                            type: object
                            properties:
                              add:
                                type: array
                                items:
                                  type: string
                              drop:
                                type: array
                                items:
                                  type: string
                          seLinuxOptions:
                            type: object
                            properties:
                              role:
                                type: string
                              level:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                          procMount:
                            type: string
                          allowPrivilegeEscalation:
                            type: boolean
                          runAsGroup:
                            type: number
                          runAsNonRoot:
                            type: boolean
                          readOnlyRootFilesystem:
                            type: boolean
                      env:
                        type: array
                        items:
                          type: object
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                            valueFrom:
                              type: object
                              properties:
                                secretKeyRef:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    key:
                                      type: string
                                resourceFieldRef:
                                  type: object
                                  properties:
                                    divisor:
                                      type: string
                                    resource:
                                      type: string
                                    containerName:
                                      type: string
                                configMapKeyRef:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    key:
                                      type: string
                                fieldRef:
                                  type: object
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                      ports:
                        type: array
                        items:
                          type: object
                          properties:
                            protocol:
                              type: string
                            hostIP:
                              type: string
                            name:
                              type: string
                            containerPort:
                              type: number
                            hostPort:
                              type: number
                      command:
                        type: array
                        items:
                          type: string
                      volumeMounts:
                        type: array
                        items:
                          type: object
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                      args:
                        type: array
                        items:
                          type: string
                      lifecycle:
                        type: object
                        properties:
                          postStart:
                            type: object
                            properties:
                              tcpSocket:
                                type: object
                                properties:
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                              exec:
                                type: object
                                properties:
                                  command:
                                    type: array
                                    items:
                                      type: string
                              httpGet:
                                type: object
                                properties:
                                  path:
                                    type: string
                                  scheme:
                                    type: string
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                                  httpHeaders:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        name:
                                          type: string
                                        value:
                                          type: string
                          preStop:
                            type: object
                            properties:
                              tcpSocket:
                                type: object
                                properties:
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                              exec:
                                type: object
                                properties:
                                  command:
                                    type: array
                                    items:
                                      type: string
                              httpGet:
                                type: object
                                properties:
                                  path:
                                    type: string
                                  scheme:
                                    type: string
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                                  httpHeaders:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        name:
                                          type: string
                                        value:
                                          type: string
                      name:
                        type: string
                      tty:
                        type: boolean
                      readinessProbe:
                        type: object
                        properties:
                          failureThreshold:
                            type: number
                          periodSeconds:
                            type: number
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          timeoutSeconds:
                            type: number
                          successThreshold:
                            type: number
                          initialDelaySeconds:
                            type: number
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      stdinOnce:
                        type: boolean
                      envFrom:
                        type: array
                        items:
                          type: object
                          properties:
                            configMapRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                            prefix:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                containerSecurityContext:
                  type: object
                  description: Container-level security attributes. Will override
                    any matching pod-level attributes.
                  properties:
                    privileged:
                      type: boolean
                    runAsUser:
                      type: number
                    capabilities:
                      type: object
                      properties:
                        add:
                          type: array
                          items:
                            type: string
                        drop:
                          type: array
                          items:
                            type: string
                    seLinuxOptions:
                      type: object
                      properties:
                        role:
                          type: string
                        level:
                          type: string
                        type:
                          type: string
                        user:
                          type: string
                    procMount:
                      type: string
                    allowPrivilegeEscalation:
                      type: boolean
                    runAsGroup:
                      type: number
                    runAsNonRoot:
                      type: boolean
                    readOnlyRootFilesystem:
                      type: boolean
                schedulerName:
                  type: string
                  description: If specified, the pod will be dispatched by specified
                    scheduler. If not specified, the pod will be dispatched by default
                    scheduler.
                initContainers:
                  type: array
                  description: Initialization containers to be included in the server
                    pod.
                  items:
                    type: object
                    properties:
                      volumeDevices:
                        type: array
                        items:
                          type: object
                          properties:
                            devicePath:
                              type: string
                            name:
                              type: string
                      image:
                        type: string
                      imagePullPolicy:
                        type: string
                      livenessProbe:
                        type: object
                        properties:
                          failureThreshold:
                            type: number
                          periodSeconds:
                            type: number
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          timeoutSeconds:
                            type: number
                          successThreshold:
                            type: number
                          initialDelaySeconds:
                            type: number
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      stdin:
                        type: boolean
                      terminationMessagePolicy:
                        type: string
                      terminationMessagePath:
                        type: string
                      workingDir:
                        type: string
                      resources:
                        type: object
                        properties:
                          requests:
                            type: object
                            properties: {}
                          limits:
                            type: object
                            properties: {}
                      securityContext:
                        type: object
                        properties:
                          privileged:
                            type: boolean
                          runAsUser:
                            type: number
                          capabilities:
                            type: object
                            properties:
                              add:
                                type: array
                                items:
                                  type: string
                              drop:
                                type: array
                                items:
                                  type: string
                          seLinuxOptions:
                            type: object
                            properties:
                              role:
                                type: string
                              level:
                                type: string
                              type:
                                type: string
                              user:
                                type: string
                          procMount:
                            type: string
                          allowPrivilegeEscalation:
                            type: boolean
                          runAsGroup:
                            type: number
                          runAsNonRoot:
                            type: boolean
                          readOnlyRootFilesystem:
                            type: boolean
                      env:
                        type: array
                        items:
                          type: object
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                            valueFrom:
                              type: object
                              properties:
                                secretKeyRef:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    key:
                                      type: string
                                resourceFieldRef:
                                  type: object
                                  properties:
                                    divisor:
                                      type: string
                                    resource:
                                      type: string
                                    containerName:
                                      type: string
                                configMapKeyRef:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    optional:
                                      type: boolean
                                    key:
                                      type: string
                                fieldRef:
                                  type: object
                                  properties:
                                    apiVersion:
                                      type: string
                                    fieldPath:
                                      type: string
                      ports:
                        type: array
                        items:
                          type: object
                          properties:
                            protocol:
                              type: string
                            hostIP:
                              type: string
                            name:
                              type: string
                            containerPort:
                              type: number
                            hostPort:
                              type: number
                      command:
                        type: array
                        items:
                          type: string
                      volumeMounts:
                        type: array
                        items:
                          type: object
                          properties:
                            mountPath:
                              type: string
                            mountPropagation:
                              type: string
                            name:
                              type: string
                            readOnly:
                              type: boolean
                            subPath:
                              type: string
                            subPathExpr:
                              type: string
                      args:
                        type: array
                        items:
                          type: string
                      lifecycle:
                        type: object
                        properties:
                          postStart:
                            type: object
                            properties:
                              tcpSocket:
                                type: object
                                properties:
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                              exec:
                                type: object
                                properties:
                                  command:
                                    type: array
                                    items:
                                      type: string
                              httpGet:
                                type: object
                                properties:
                                  path:
                                    type: string
                                  scheme:
                                    type: string
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                                  httpHeaders:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        name:
                                          type: string
                                        value:
                                          type: string
                          preStop:
                            type: object
                            properties:
                              tcpSocket:
                                type: object
                                properties:
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                              exec:
                                type: object
                                properties:
                                  command:
                                    type: array
                                    items:
                                      type: string
                              httpGet:
                                type: object
                                properties:
                                  path:
                                    type: string
                                  scheme:
                                    type: string
                                  port:
                                    type: object
                                    properties:
                                      intValue:
                                        type: number
                                      isInt:
                                        type: boolean
                                      strValue:
                                        type: string
                                    required:
                                    - isInt
                                  host:
                                    type: string
                                  httpHeaders:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        name:
                                          type: string
                                        value:
                                          type: string
                      name:
                        type: string
                      tty:
                        type: boolean
                      readinessProbe:
                        type: object
                        properties:
                          failureThreshold:
                            type: number
                          periodSeconds:
                            type: number
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          timeoutSeconds:
                            type: number
                          successThreshold:
                            type: number
                          initialDelaySeconds:
                            type: number
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      stdinOnce:
                        type: boolean
                      envFrom:
                        type: array
                        items:
                          type: object
                          properties:
                            configMapRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                            prefix:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                shutdown:
                  type: object
                  description: Configures how the operator should shutdown the server
                    instance.
                  properties:
                    ignoreSessions:
                      type: boolean
                      description: For graceful shutdown only, indicates to ignore
                        pending HTTP sessions during in-flight work handling. Not
                        required. Defaults to false.
                    shutdownType:
                      type: string
                      description: Tells the operator how to shutdown server instances.
                        Not required. Defaults to graceful shutdown.
                      enum:
                      - Graceful
                      - Forced
                    timeoutSeconds:
                      type: number
                      description: For graceful shutdown only, number of seconds to
                        wait before aborting in-flight work and shutting down the
                        server. Not required. Defaults to 30 seconds.
                affinity:
                  type: object
                  description: If specified, the pod's scheduling constraints
                  properties:
                    nodeAffinity:
                      type: object
                      properties:
                        requiredDuringSchedulingIgnoredDuringExecution:
                          type: object
                          properties:
                            nodeSelectorTerms:
                              type: array
                              items:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchFields:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                        preferredDuringSchedulingIgnoredDuringExecution:
                          type: array
                          items:
                            type: object
                            properties:
                              preference:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchFields:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                              weight:
                                type: number
                    podAffinity:
                      type: object
                      properties:
                        requiredDuringSchedulingIgnoredDuringExecution:
                          type: array
                          items:
                            type: object
                            properties:
                              labelSelector:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchLabels:
                                    type: object
                                    properties: {}
                              topologyKey:
                                type: string
                              namespaces:
                                type: array
                                items:
                                  type: string
                        preferredDuringSchedulingIgnoredDuringExecution:
                          type: array
                          items:
                            type: object
                            properties:
                              podAffinityTerm:
                                type: object
                                properties:
                                  labelSelector:
                                    type: object
                                    properties:
                                      matchExpressions:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            values:
                                              type: array
                                              items:
                                                type: string
                                            key:
                                              type: string
                                            operator:
                                              type: string
                                      matchLabels:
                                        type: object
                                        properties: {}
                                  topologyKey:
                                    type: string
                                  namespaces:
                                    type: array
                                    items:
                                      type: string
                              weight:
                                type: number
                    podAntiAffinity:
                      type: object
                      properties:
                        requiredDuringSchedulingIgnoredDuringExecution:
                          type: array
                          items:
                            type: object
                            properties:
                              labelSelector:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchLabels:
                                    type: object
                                    properties: {}
                              topologyKey:
                                type: string
                              namespaces:
                                type: array
                                items:
                                  type: string
                        preferredDuringSchedulingIgnoredDuringExecution:
                          type: array
                          items:
                            type: object
                            properties:
                              podAffinityTerm:
                                type: object
                                properties:
                                  labelSelector:
                                    type: object
                                    properties:
                                      matchExpressions:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            values:
                                              type: array
                                              items:
                                                type: string
                                            key:
                                              type: string
                                            operator:
                                              type: string
                                      matchLabels:
                                        type: object
                                        properties: {}
                                  topologyKey:
                                    type: string
                                  namespaces:
                                    type: array
                                    items:
                                      type: string
                              weight:
                                type: number
            serverStartPolicy:
              type: string
              description: The strategy for deciding whether to start a server. Legal
                values are ALWAYS, NEVER, or IF_NEEDED.
              enum:
              - ALWAYS
              - NEVER
              - IF_NEEDED
            adminService:
              type: object
              description: Configures which of the Administration Server's WebLogic
                admin channels should be exposed outside the Kubernetes cluster via
                a node port service.
              properties:
                channels:
                  type: array
                  description: Specifies which of the Administration Server's WebLogic
                    channels should be exposed outside the Kubernetes cluster via
                    a node port service, along with the node port for each channel.
                    If not specified, the Administration Server's node port service
                    will not be created.
                  items:
                    description: Describes a single channel used by the Administration
                      Server.
                    type: object
                    properties:
                      channelName:
                        description: "Name of channel.\n'default' refers to the Administration\
                          \ Server's default channel (configured via the ServerMBean's\
                          \ ListenPort) \n'default-secure' refers to the Administration\
                          \ Server's default secure channel (configured via the ServerMBean's\
                          \ SSLMBean's ListenPort) \n'default-admin' refers to the\
                          \ Administration Server's default administrative channel\
                          \ (configured via the DomainMBean's AdministrationPort)\
                          \ \nOtherwise, the name is the name of one of the Administration\
                          \ Server's network access points (configured via the ServerMBean's\
                          \ NetworkAccessMBeans)."
                        type: string
                      nodePort:
                        description: Specifies the port number used to access the
                          WebLogic channel outside of the Kubernetes cluster. If not
                          specified, defaults to the port defined by the WebLogic
                          channel.
                        type: number
                    required:
                    - channelName
                annotations:
                  type: object
                  description: Annotations to associate with the external channel
                    service.
                  properties: {}
                labels:
                  type: object
                  description: Labels to associate with the external channel service.
                  properties: {}
            restartVersion:
              type: string
              description: If present, every time this value is updated the operator
                will restart the required servers.
        serverPod:
          type: object
          description: Configuration affecting server pods.
          properties:
            nodeName:
              type: string
              description: NodeName is a request to schedule this pod onto a specific
                node. If it is non-empty, the scheduler simply schedules this pod
                onto that node, assuming that it fits resource requirements.
            livenessProbe:
              type: object
              description: Settings for the liveness probe associated with a server.
              properties:
                periodSeconds:
                  type: number
                  description: The number of seconds between checks.
                timeoutSeconds:
                  type: number
                  description: The number of seconds with no response that indicates
                    a failure.
                initialDelaySeconds:
                  type: number
                  description: The number of seconds before the first check is performed.
            readinessGates:
              type: array
              description: 'If specified, all readiness gates will be evaluated for
                pod readiness. A pod is ready when all its containers are ready AND
                all conditions specified in the readiness gates have status equal
                to "True" More info: https://github.com/kubernetes/community/blob/master/keps/sig-network/0007-pod-ready%2B%2B.md'
              items:
                type: object
                properties:
                  conditionType:
                    type: string
            serviceAccountName:
              type: string
              description: Name of the ServiceAccount to be used to run this pod.
                If it is not set, default ServiceAccount will be used. The ServiceAccount
                has to exist at the time the pod is created.
            podSecurityContext:
              type: object
              description: Pod-level security attributes.
              properties:
                runAsUser:
                  type: number
                seLinuxOptions:
                  type: object
                  properties:
                    role:
                      type: string
                    level:
                      type: string
                    type:
                      type: string
                    user:
                      type: string
                fsGroup:
                  type: number
                supplementalGroups:
                  type: array
                  items:
                    type: number
                runAsGroup:
                  type: number
                runAsNonRoot:
                  type: boolean
                sysctls:
                  type: array
                  items:
                    type: object
                    properties:
                      name:
                        type: string
                      value:
                        type: string
            priorityClassName:
              type: string
              description: If specified, indicates the pod's priority. "system-node-critical"
                and "system-cluster-critical" are two special keywords which indicate
                the highest priorities with the former being the highest priority.
                Any other name must be defined by creating a PriorityClass object
                with that name. If not specified, the pod priority will be default
                or zero if there is no default.
            volumes:
              type: array
              description: Additional volumes to be created in the server pod.
              items:
                type: object
                properties:
                  quobyte:
                    type: object
                    properties:
                      volume:
                        type: string
                      registry:
                        type: string
                      readOnly:
                        type: boolean
                      user:
                        type: string
                      tenant:
                        type: string
                      group:
                        type: string
                  azureFile:
                    type: object
                    properties:
                      secretName:
                        type: string
                      readOnly:
                        type: boolean
                      shareName:
                        type: string
                  flexVolume:
                    type: object
                    properties:
                      driver:
                        type: string
                      options:
                        type: object
                        properties: {}
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                  secret:
                    type: object
                    properties:
                      secretName:
                        type: string
                      defaultMode:
                        type: number
                      optional:
                        type: boolean
                      items:
                        type: array
                        items:
                          type: object
                          properties:
                            mode:
                              type: number
                            path:
                              type: string
                            key:
                              type: string
                  projected:
                    type: object
                    properties:
                      sources:
                        type: array
                        items:
                          type: object
                          properties:
                            downwardAPI:
                              type: object
                              properties:
                                items:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      mode:
                                        type: number
                                      path:
                                        type: string
                                      resourceFieldRef:
                                        type: object
                                        properties:
                                          divisor:
                                            type: string
                                          resource:
                                            type: string
                                          containerName:
                                            type: string
                                      fieldRef:
                                        type: object
                                        properties:
                                          apiVersion:
                                            type: string
                                          fieldPath:
                                            type: string
                            configMap:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                items:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      mode:
                                        type: number
                                      path:
                                        type: string
                                      key:
                                        type: string
                            secret:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                items:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      mode:
                                        type: number
                                      path:
                                        type: string
                                      key:
                                        type: string
                            serviceAccountToken:
                              type: object
                              properties:
                                path:
                                  type: string
                                audience:
                                  type: string
                                expirationSeconds:
                                  type: number
                      defaultMode:
                        type: number
                  cephfs:
                    type: object
                    properties:
                      path:
                        type: string
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      secretFile:
                        type: string
                      readOnly:
                        type: boolean
                      user:
                        type: string
                      monitors:
                        type: array
                        items:
                          type: string
                  scaleIO:
                    type: object
                    properties:
                      system:
                        type: string
                      protectionDomain:
                        type: string
                      sslEnabled:
                        type: boolean
                      storageMode:
                        type: string
                      volumeName:
                        type: string
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                      storagePool:
                        type: string
                      gateway:
                        type: string
                  emptyDir:
                    type: object
                    properties:
                      sizeLimit:
                        type: string
                      medium:
                        type: string
                  glusterfs:
                    type: object
                    properties:
                      path:
                        type: string
                      endpoints:
                        type: string
                      readOnly:
                        type: boolean
                  gcePersistentDisk:
                    type: object
                    properties:
                      partition:
                        type: number
                      readOnly:
                        type: boolean
                      pdName:
                        type: string
                      fsType:
                        type: string
                  photonPersistentDisk:
                    type: object
                    properties:
                      pdID:
                        type: string
                      fsType:
                        type: string
                  azureDisk:
                    type: object
                    properties:
                      diskName:
                        type: string
                      kind:
                        type: string
                      readOnly:
                        type: boolean
                      cachingMode:
                        type: string
                      diskURI:
                        type: string
                      fsType:
                        type: string
                  cinder:
                    type: object
                    properties:
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      volumeID:
                        type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                  downwardAPI:
                    type: object
                    properties:
                      defaultMode:
                        type: number
                      items:
                        type: array
                        items:
                          type: object
                          properties:
                            mode:
                              type: number
                            path:
                              type: string
                            resourceFieldRef:
                              type: object
                              properties:
                                divisor:
                                  type: string
                                resource:
                                  type: string
                                containerName:
                                  type: string
                            fieldRef:
                              type: object
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                  awsElasticBlockStore:
                    type: object
                    properties:
                      partition:
                        type: number
                      volumeID:
                        type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                  flocker:
                    type: object
                    properties:
                      datasetName:
                        type: string
                      datasetUUID:
                        type: string
                  iscsi:
                    type: object
                    properties:
                      chapAuthSession:
                        type: boolean
                      iscsiInterface:
                        type: string
                      lun:
                        type: number
                      chapAuthDiscovery:
                        type: boolean
                      iqn:
                        type: string
                      portals:
                        type: array
                        items:
                          type: string
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      initiatorName:
                        type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                      targetPortal:
                        type: string
                  rbd:
                    type: object
                    properties:
                      image:
                        type: string
                      pool:
                        type: string
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                      keyring:
                        type: string
                      user:
                        type: string
                      monitors:
                        type: array
                        items:
                          type: string
                  configMap:
                    type: object
                    properties:
                      defaultMode:
                        type: number
                      name:
                        type: string
                      optional:
                        type: boolean
                      items:
                        type: array
                        items:
                          type: object
                          properties:
                            mode:
                              type: number
                            path:
                              type: string
                            key:
                              type: string
                  storageos:
                    type: object
                    properties:
                      volumeNamespace:
                        type: string
                      volumeName:
                        type: string
                      secretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                  csi:
                    type: object
                    properties:
                      driver:
                        type: string
                      nodePublishSecretRef:
                        type: object
                        properties:
                          name:
                            type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                      volumeAttributes:
                        type: object
                        properties: {}
                  name:
                    type: string
                  nfs:
                    type: object
                    properties:
                      path:
                        type: string
                      server:
                        type: string
                      readOnly:
                        type: boolean
                  persistentVolumeClaim:
                    type: object
                    properties:
                      claimName:
                        type: string
                      readOnly:
                        type: boolean
                  gitRepo:
                    type: object
                    properties:
                      repository:
                        type: string
                      directory:
                        type: string
                      revision:
                        type: string
                  portworxVolume:
                    type: object
                    properties:
                      volumeID:
                        type: string
                      readOnly:
                        type: boolean
                      fsType:
                        type: string
                  vsphereVolume:
                    type: object
                    properties:
                      storagePolicyName:
                        type: string
                      storagePolicyID:
                        type: string
                      volumePath:
                        type: string
                      fsType:
                        type: string
                  fc:
                    type: object
                    properties:
                      lun:
                        type: number
                      targetWWNs:
                        type: array
                        items:
                          type: string
                      readOnly:
                        type: boolean
                      wwids:
                        type: array
                        items:
                          type: string
                      fsType:
                        type: string
                  hostPath:
                    type: object
                    properties:
                      path:
                        type: string
                      type:
                        type: string
            resources:
              type: object
              description: Memory and CPU minimum requirements and limits for the
                server.
              properties:
                requests:
                  type: object
                  properties: {}
                limits:
                  type: object
                  properties: {}
            annotations:
              type: object
              description: The annotations to be attached to generated resources.
              properties: {}
            env:
              type: array
              description: A list of environment variables to add to a server.
              items:
                type: object
                properties:
                  name:
                    type: string
                  value:
                    type: string
                  valueFrom:
                    type: object
                    properties:
                      secretKeyRef:
                        type: object
                        properties:
                          name:
                            type: string
                          optional:
                            type: boolean
                          key:
                            type: string
                      resourceFieldRef:
                        type: object
                        properties:
                          divisor:
                            type: string
                          resource:
                            type: string
                          containerName:
                            type: string
                      configMapKeyRef:
                        type: object
                        properties:
                          name:
                            type: string
                          optional:
                            type: boolean
                          key:
                            type: string
                      fieldRef:
                        type: object
                        properties:
                          apiVersion:
                            type: string
                          fieldPath:
                            type: string
            restartPolicy:
              type: string
              description: 'Restart policy for all containers within the pod. One
                of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy'
            nodeSelector:
              type: object
              description: Selector which must match a node's labels for the pod to
                be scheduled on that node.
              properties: {}
            volumeMounts:
              type: array
              description: Additional volume mounts for the server pod.
              items:
                type: object
                properties:
                  mountPath:
                    type: string
                  mountPropagation:
                    type: string
                  name:
                    type: string
                  readOnly:
                    type: boolean
                  subPath:
                    type: string
                  subPathExpr:
                    type: string
            labels:
              type: object
              description: The labels to be attached to generated resources. The label
                names must not start with 'weblogic.'.
              properties: {}
            runtimeClassName:
              type: string
              description: 'RuntimeClassName refers to a RuntimeClass object in the
                node.k8s.io group, which should be used to run this pod.  If no RuntimeClass
                resource matches the named class, the pod will not be run. If unset
                or empty, the "legacy" RuntimeClass will be used, which is an implicit
                class with an empty definition that uses the default runtime handler.
                More info: https://github.com/kubernetes/community/blob/master/keps/sig-node/0014-runtime-class.md
                This is an alpha feature and may change in the future.'
            tolerations:
              type: array
              description: If specified, the pod's tolerations.
              items:
                type: object
                properties:
                  effect:
                    type: string
                  tolerationSeconds:
                    type: number
                  value:
                    type: string
                  key:
                    type: string
                  operator:
                    type: string
            readinessProbe:
              type: object
              description: Settings for the readiness probe associated with a server.
              properties:
                periodSeconds:
                  type: number
                  description: The number of seconds between checks.
                timeoutSeconds:
                  type: number
                  description: The number of seconds with no response that indicates
                    a failure.
                initialDelaySeconds:
                  type: number
                  description: The number of seconds before the first check is performed.
            containers:
              type: array
              description: Additional containers to be included in the server pod.
              items:
                type: object
                properties:
                  volumeDevices:
                    type: array
                    items:
                      type: object
                      properties:
                        devicePath:
                          type: string
                        name:
                          type: string
                  image:
                    type: string
                  imagePullPolicy:
                    type: string
                  livenessProbe:
                    type: object
                    properties:
                      failureThreshold:
                        type: number
                      periodSeconds:
                        type: number
                      tcpSocket:
                        type: object
                        properties:
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                      timeoutSeconds:
                        type: number
                      successThreshold:
                        type: number
                      initialDelaySeconds:
                        type: number
                      exec:
                        type: object
                        properties:
                          command:
                            type: array
                            items:
                              type: string
                      httpGet:
                        type: object
                        properties:
                          path:
                            type: string
                          scheme:
                            type: string
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                          httpHeaders:
                            type: array
                            items:
                              type: object
                              properties:
                                name:
                                  type: string
                                value:
                                  type: string
                  stdin:
                    type: boolean
                  terminationMessagePolicy:
                    type: string
                  terminationMessagePath:
                    type: string
                  workingDir:
                    type: string
                  resources:
                    type: object
                    properties:
                      requests:
                        type: object
                        properties: {}
                      limits:
                        type: object
                        properties: {}
                  securityContext:
                    type: object
                    properties:
                      privileged:
                        type: boolean
                      runAsUser:
                        type: number
                      capabilities:
                        type: object
                        properties:
                          add:
                            type: array
                            items:
                              type: string
                          drop:
                            type: array
                            items:
                              type: string
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      procMount:
                        type: string
                      allowPrivilegeEscalation:
                        type: boolean
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      readOnlyRootFilesystem:
                        type: boolean
                  env:
                    type: array
                    items:
                      type: object
                      properties:
                        name:
                          type: string
                        value:
                          type: string
                        valueFrom:
                          type: object
                          properties:
                            secretKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            resourceFieldRef:
                              type: object
                              properties:
                                divisor:
                                  type: string
                                resource:
                                  type: string
                                containerName:
                                  type: string
                            configMapKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            fieldRef:
                              type: object
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                  ports:
                    type: array
                    items:
                      type: object
                      properties:
                        protocol:
                          type: string
                        hostIP:
                          type: string
                        name:
                          type: string
                        containerPort:
                          type: number
                        hostPort:
                          type: number
                  command:
                    type: array
                    items:
                      type: string
                  volumeMounts:
                    type: array
                    items:
                      type: object
                      properties:
                        mountPath:
                          type: string
                        mountPropagation:
                          type: string
                        name:
                          type: string
                        readOnly:
                          type: boolean
                        subPath:
                          type: string
                        subPathExpr:
                          type: string
                  args:
                    type: array
                    items:
                      type: string
                  lifecycle:
                    type: object
                    properties:
                      postStart:
                        type: object
                        properties:
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      preStop:
                        type: object
                        properties:
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                  name:
                    type: string
                  tty:
                    type: boolean
                  readinessProbe:
                    type: object
                    properties:
                      failureThreshold:
                        type: number
                      periodSeconds:
                        type: number
                      tcpSocket:
                        type: object
                        properties:
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                      timeoutSeconds:
                        type: number
                      successThreshold:
                        type: number
                      initialDelaySeconds:
                        type: number
                      exec:
                        type: object
                        properties:
                          command:
                            type: array
                            items:
                              type: string
                      httpGet:
                        type: object
                        properties:
                          path:
                            type: string
                          scheme:
                            type: string
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                          httpHeaders:
                            type: array
                            items:
                              type: object
                              properties:
                                name:
                                  type: string
                                value:
                                  type: string
                  stdinOnce:
                    type: boolean
                  envFrom:
                    type: array
                    items:
                      type: object
                      properties:
                        configMapRef:
                          type: object
                          properties:
                            name:
                              type: string
                            optional:
                              type: boolean
                        prefix:
                          type: string
                        secretRef:
                          type: object
                          properties:
                            name:
                              type: string
                            optional:
                              type: boolean
            containerSecurityContext:
              type: object
              description: Container-level security attributes. Will override any
                matching pod-level attributes.
              properties:
                privileged:
                  type: boolean
                runAsUser:
                  type: number
                capabilities:
                  type: object
                  properties:
                    add:
                      type: array
                      items:
                        type: string
                    drop:
                      type: array
                      items:
                        type: string
                seLinuxOptions:
                  type: object
                  properties:
                    role:
                      type: string
                    level:
                      type: string
                    type:
                      type: string
                    user:
                      type: string
                procMount:
                  type: string
                allowPrivilegeEscalation:
                  type: boolean
                runAsGroup:
                  type: number
                runAsNonRoot:
                  type: boolean
                readOnlyRootFilesystem:
                  type: boolean
            schedulerName:
              type: string
              description: If specified, the pod will be dispatched by specified scheduler.
                If not specified, the pod will be dispatched by default scheduler.
            initContainers:
              type: array
              description: Initialization containers to be included in the server
                pod.
              items:
                type: object
                properties:
                  volumeDevices:
                    type: array
                    items:
                      type: object
                      properties:
                        devicePath:
                          type: string
                        name:
                          type: string
                  image:
                    type: string
                  imagePullPolicy:
                    type: string
                  livenessProbe:
                    type: object
                    properties:
                      failureThreshold:
                        type: number
                      periodSeconds:
                        type: number
                      tcpSocket:
                        type: object
                        properties:
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                      timeoutSeconds:
                        type: number
                      successThreshold:
                        type: number
                      initialDelaySeconds:
                        type: number
                      exec:
                        type: object
                        properties:
                          command:
                            type: array
                            items:
                              type: string
                      httpGet:
                        type: object
                        properties:
                          path:
                            type: string
                          scheme:
                            type: string
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                          httpHeaders:
                            type: array
                            items:
                              type: object
                              properties:
                                name:
                                  type: string
                                value:
                                  type: string
                  stdin:
                    type: boolean
                  terminationMessagePolicy:
                    type: string
                  terminationMessagePath:
                    type: string
                  workingDir:
                    type: string
                  resources:
                    type: object
                    properties:
                      requests:
                        type: object
                        properties: {}
                      limits:
                        type: object
                        properties: {}
                  securityContext:
                    type: object
                    properties:
                      privileged:
                        type: boolean
                      runAsUser:
                        type: number
                      capabilities:
                        type: object
                        properties:
                          add:
                            type: array
                            items:
                              type: string
                          drop:
                            type: array
                            items:
                              type: string
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      procMount:
                        type: string
                      allowPrivilegeEscalation:
                        type: boolean
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      readOnlyRootFilesystem:
                        type: boolean
                  env:
                    type: array
                    items:
                      type: object
                      properties:
                        name:
                          type: string
                        value:
                          type: string
                        valueFrom:
                          type: object
                          properties:
                            secretKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            resourceFieldRef:
                              type: object
                              properties:
                                divisor:
                                  type: string
                                resource:
                                  type: string
                                containerName:
                                  type: string
                            configMapKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            fieldRef:
                              type: object
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                  ports:
                    type: array
                    items:
                      type: object
                      properties:
                        protocol:
                          type: string
                        hostIP:
                          type: string
                        name:
                          type: string
                        containerPort:
                          type: number
                        hostPort:
                          type: number
                  command:
                    type: array
                    items:
                      type: string
                  volumeMounts:
                    type: array
                    items:
                      type: object
                      properties:
                        mountPath:
                          type: string
                        mountPropagation:
                          type: string
                        name:
                          type: string
                        readOnly:
                          type: boolean
                        subPath:
                          type: string
                        subPathExpr:
                          type: string
                  args:
                    type: array
                    items:
                      type: string
                  lifecycle:
                    type: object
                    properties:
                      postStart:
                        type: object
                        properties:
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                      preStop:
                        type: object
                        properties:
                          tcpSocket:
                            type: object
                            properties:
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                          exec:
                            type: object
                            properties:
                              command:
                                type: array
                                items:
                                  type: string
                          httpGet:
                            type: object
                            properties:
                              path:
                                type: string
                              scheme:
                                type: string
                              port:
                                type: object
                                properties:
                                  intValue:
                                    type: number
                                  isInt:
                                    type: boolean
                                  strValue:
                                    type: string
                                required:
                                - isInt
                              host:
                                type: string
                              httpHeaders:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                  name:
                    type: string
                  tty:
                    type: boolean
                  readinessProbe:
                    type: object
                    properties:
                      failureThreshold:
                        type: number
                      periodSeconds:
                        type: number
                      tcpSocket:
                        type: object
                        properties:
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                      timeoutSeconds:
                        type: number
                      successThreshold:
                        type: number
                      initialDelaySeconds:
                        type: number
                      exec:
                        type: object
                        properties:
                          command:
                            type: array
                            items:
                              type: string
                      httpGet:
                        type: object
                        properties:
                          path:
                            type: string
                          scheme:
                            type: string
                          port:
                            type: object
                            properties:
                              intValue:
                                type: number
                              isInt:
                                type: boolean
                              strValue:
                                type: string
                            required:
                            - isInt
                          host:
                            type: string
                          httpHeaders:
                            type: array
                            items:
                              type: object
                              properties:
                                name:
                                  type: string
                                value:
                                  type: string
                  stdinOnce:
                    type: boolean
                  envFrom:
                    type: array
                    items:
                      type: object
                      properties:
                        configMapRef:
                          type: object
                          properties:
                            name:
                              type: string
                            optional:
                              type: boolean
                        prefix:
                          type: string
                        secretRef:
                          type: object
                          properties:
                            name:
                              type: string
                            optional:
                              type: boolean
            shutdown:
              type: object
              description: Configures how the operator should shutdown the server
                instance.
              properties:
                ignoreSessions:
                  type: boolean
                  description: For graceful shutdown only, indicates to ignore pending
                    HTTP sessions during in-flight work handling. Not required. Defaults
                    to false.
                shutdownType:
                  type: string
                  description: Tells the operator how to shutdown server instances.
                    Not required. Defaults to graceful shutdown.
                  enum:
                  - Graceful
                  - Forced
                timeoutSeconds:
                  type: number
                  description: For graceful shutdown only, number of seconds to wait
                    before aborting in-flight work and shutting down the server. Not
                    required. Defaults to 30 seconds.
            affinity:
              type: object
              description: If specified, the pod's scheduling constraints
              properties:
                nodeAffinity:
                  type: object
                  properties:
                    requiredDuringSchedulingIgnoredDuringExecution:
                      type: object
                      properties:
                        nodeSelectorTerms:
                          type: array
                          items:
                            type: object
                            properties:
                              matchExpressions:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                              matchFields:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                    preferredDuringSchedulingIgnoredDuringExecution:
                      type: array
                      items:
                        type: object
                        properties:
                          preference:
                            type: object
                            properties:
                              matchExpressions:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                              matchFields:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                          weight:
                            type: number
                podAffinity:
                  type: object
                  properties:
                    requiredDuringSchedulingIgnoredDuringExecution:
                      type: array
                      items:
                        type: object
                        properties:
                          labelSelector:
                            type: object
                            properties:
                              matchExpressions:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                              matchLabels:
                                type: object
                                properties: {}
                          topologyKey:
                            type: string
                          namespaces:
                            type: array
                            items:
                              type: string
                    preferredDuringSchedulingIgnoredDuringExecution:
                      type: array
                      items:
                        type: object
                        properties:
                          podAffinityTerm:
                            type: object
                            properties:
                              labelSelector:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchLabels:
                                    type: object
                                    properties: {}
                              topologyKey:
                                type: string
                              namespaces:
                                type: array
                                items:
                                  type: string
                          weight:
                            type: number
                podAntiAffinity:
                  type: object
                  properties:
                    requiredDuringSchedulingIgnoredDuringExecution:
                      type: array
                      items:
                        type: object
                        properties:
                          labelSelector:
                            type: object
                            properties:
                              matchExpressions:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    values:
                                      type: array
                                      items:
                                        type: string
                                    key:
                                      type: string
                                    operator:
                                      type: string
                              matchLabels:
                                type: object
                                properties: {}
                          topologyKey:
                            type: string
                          namespaces:
                            type: array
                            items:
                              type: string
                    preferredDuringSchedulingIgnoredDuringExecution:
                      type: array
                      items:
                        type: object
                        properties:
                          podAffinityTerm:
                            type: object
                            properties:
                              labelSelector:
                                type: object
                                properties:
                                  matchExpressions:
                                    type: array
                                    items:
                                      type: object
                                      properties:
                                        values:
                                          type: array
                                          items:
                                            type: string
                                        key:
                                          type: string
                                        operator:
                                          type: string
                                  matchLabels:
                                    type: object
                                    properties: {}
                              topologyKey:
                                type: string
                              namespaces:
                                type: array
                                items:
                                  type: string
                          weight:
                            type: number
        logHome:
          type: string
          description: The in-pod name of the directory in which to store the domain,
            node manager, server logs, and server  *.out files
        includeServerOutInPodLog:
          type: boolean
          description: If true (the default), the server .out file will be included
            in the pod's stdout.
        managedServers:
          type: array
          description: Configuration for individual Managed Servers.
          items:
            description: ManagedServer represents the operator configuration for a
              single Managed Server.
            type: object
            properties:
              serverStartState:
                description: The state in which the server is to be started. Use ADMIN
                  if server should start in the admin state. Defaults to RUNNING.
                type: string
                enum:
                - RUNNING
                - ADMIN
              serverService:
                description: Customization affecting ClusterIP Kubernetes services
                  for WebLogic Server instances.
                type: object
                properties:
                  precreateService:
                    description: If true, operator will create server services even
                      for server instances without running pods.
                    type: boolean
                  annotations:
                    description: The annotations to be attached to generated resources.
                    type: object
                    properties: {}
                  labels:
                    description: The labels to be attached to generated resources.
                      The label names must not start with 'weblogic.'.
                    type: object
                    properties: {}
              serverName:
                description: The name of the Managed Server. Required.
                type: string
              serverPod:
                description: Configuration affecting server pods.
                type: object
                properties:
                  nodeName:
                    description: NodeName is a request to schedule this pod onto a
                      specific node. If it is non-empty, the scheduler simply schedules
                      this pod onto that node, assuming that it fits resource requirements.
                    type: string
                  livenessProbe:
                    description: Settings for the liveness probe associated with a
                      server.
                    type: object
                    properties:
                      periodSeconds:
                        description: The number of seconds between checks.
                        type: number
                      timeoutSeconds:
                        description: The number of seconds with no response that indicates
                          a failure.
                        type: number
                      initialDelaySeconds:
                        description: The number of seconds before the first check
                          is performed.
                        type: number
                  readinessGates:
                    description: 'If specified, all readiness gates will be evaluated
                      for pod readiness. A pod is ready when all its containers are
                      ready AND all conditions specified in the readiness gates have
                      status equal to "True" More info: https://github.com/kubernetes/community/blob/master/keps/sig-network/0007-pod-ready%2B%2B.md'
                    type: array
                    items:
                      type: object
                      properties:
                        conditionType:
                          type: string
                  serviceAccountName:
                    description: Name of the ServiceAccount to be used to run this
                      pod. If it is not set, default ServiceAccount will be used.
                      The ServiceAccount has to exist at the time the pod is created.
                    type: string
                  podSecurityContext:
                    description: Pod-level security attributes.
                    type: object
                    properties:
                      runAsUser:
                        type: number
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      fsGroup:
                        type: number
                      supplementalGroups:
                        type: array
                        items:
                          type: number
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      sysctls:
                        type: array
                        items:
                          type: object
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                  priorityClassName:
                    description: If specified, indicates the pod's priority. "system-node-critical"
                      and "system-cluster-critical" are two special keywords which
                      indicate the highest priorities with the former being the highest
                      priority. Any other name must be defined by creating a PriorityClass
                      object with that name. If not specified, the pod priority will
                      be default or zero if there is no default.
                    type: string
                  volumes:
                    description: Additional volumes to be created in the server pod.
                    type: array
                    items:
                      type: object
                      properties:
                        quobyte:
                          type: object
                          properties:
                            volume:
                              type: string
                            registry:
                              type: string
                            readOnly:
                              type: boolean
                            user:
                              type: string
                            tenant:
                              type: string
                            group:
                              type: string
                        azureFile:
                          type: object
                          properties:
                            secretName:
                              type: string
                            readOnly:
                              type: boolean
                            shareName:
                              type: string
                        flexVolume:
                          type: object
                          properties:
                            driver:
                              type: string
                            options:
                              type: object
                              properties: {}
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        secret:
                          type: object
                          properties:
                            secretName:
                              type: string
                            defaultMode:
                              type: number
                            optional:
                              type: boolean
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  key:
                                    type: string
                        projected:
                          type: object
                          properties:
                            sources:
                              type: array
                              items:
                                type: object
                                properties:
                                  downwardAPI:
                                    type: object
                                    properties:
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            resourceFieldRef:
                                              type: object
                                              properties:
                                                divisor:
                                                  type: string
                                                resource:
                                                  type: string
                                                containerName:
                                                  type: string
                                            fieldRef:
                                              type: object
                                              properties:
                                                apiVersion:
                                                  type: string
                                                fieldPath:
                                                  type: string
                                  configMap:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            key:
                                              type: string
                                  secret:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            key:
                                              type: string
                                  serviceAccountToken:
                                    type: object
                                    properties:
                                      path:
                                        type: string
                                      audience:
                                        type: string
                                      expirationSeconds:
                                        type: number
                            defaultMode:
                              type: number
                        cephfs:
                          type: object
                          properties:
                            path:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            secretFile:
                              type: string
                            readOnly:
                              type: boolean
                            user:
                              type: string
                            monitors:
                              type: array
                              items:
                                type: string
                        scaleIO:
                          type: object
                          properties:
                            system:
                              type: string
                            protectionDomain:
                              type: string
                            sslEnabled:
                              type: boolean
                            storageMode:
                              type: string
                            volumeName:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            storagePool:
                              type: string
                            gateway:
                              type: string
                        emptyDir:
                          type: object
                          properties:
                            sizeLimit:
                              type: string
                            medium:
                              type: string
                        glusterfs:
                          type: object
                          properties:
                            path:
                              type: string
                            endpoints:
                              type: string
                            readOnly:
                              type: boolean
                        gcePersistentDisk:
                          type: object
                          properties:
                            partition:
                              type: number
                            readOnly:
                              type: boolean
                            pdName:
                              type: string
                            fsType:
                              type: string
                        photonPersistentDisk:
                          type: object
                          properties:
                            pdID:
                              type: string
                            fsType:
                              type: string
                        azureDisk:
                          type: object
                          properties:
                            diskName:
                              type: string
                            kind:
                              type: string
                            readOnly:
                              type: boolean
                            cachingMode:
                              type: string
                            diskURI:
                              type: string
                            fsType:
                              type: string
                        cinder:
                          type: object
                          properties:
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        downwardAPI:
                          type: object
                          properties:
                            defaultMode:
                              type: number
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        awsElasticBlockStore:
                          type: object
                          properties:
                            partition:
                              type: number
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        flocker:
                          type: object
                          properties:
                            datasetName:
                              type: string
                            datasetUUID:
                              type: string
                        iscsi:
                          type: object
                          properties:
                            chapAuthSession:
                              type: boolean
                            iscsiInterface:
                              type: string
                            lun:
                              type: number
                            chapAuthDiscovery:
                              type: boolean
                            iqn:
                              type: string
                            portals:
                              type: array
                              items:
                                type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            initiatorName:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            targetPortal:
                              type: string
                        rbd:
                          type: object
                          properties:
                            image:
                              type: string
                            pool:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            keyring:
                              type: string
                            user:
                              type: string
                            monitors:
                              type: array
                              items:
                                type: string
                        configMap:
                          type: object
                          properties:
                            defaultMode:
                              type: number
                            name:
                              type: string
                            optional:
                              type: boolean
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  key:
                                    type: string
                        storageos:
                          type: object
                          properties:
                            volumeNamespace:
                              type: string
                            volumeName:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        csi:
                          type: object
                          properties:
                            driver:
                              type: string
                            nodePublishSecretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            volumeAttributes:
                              type: object
                              properties: {}
                        name:
                          type: string
                        nfs:
                          type: object
                          properties:
                            path:
                              type: string
                            server:
                              type: string
                            readOnly:
                              type: boolean
                        persistentVolumeClaim:
                          type: object
                          properties:
                            claimName:
                              type: string
                            readOnly:
                              type: boolean
                        gitRepo:
                          type: object
                          properties:
                            repository:
                              type: string
                            directory:
                              type: string
                            revision:
                              type: string
                        portworxVolume:
                          type: object
                          properties:
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        vsphereVolume:
                          type: object
                          properties:
                            storagePolicyName:
                              type: string
                            storagePolicyID:
                              type: string
                            volumePath:
                              type: string
                            fsType:
                              type: string
                        fc:
                          type: object
                          properties:
                            lun:
                              type: number
                            targetWWNs:
                              type: array
                              items:
                                type: string
                            readOnly:
                              type: boolean
                            wwids:
                              type: array
                              items:
                                type: string
                            fsType:
                              type: string
                        hostPath:
                          type: object
                          properties:
                            path:
                              type: string
                            type:
                              type: string
                  resources:
                    description: Memory and CPU minimum requirements and limits for
                      the server.
                    type: object
                    properties:
                      requests:
                        type: object
                        properties: {}
                      limits:
                        type: object
                        properties: {}
                  annotations:
                    description: The annotations to be attached to generated resources.
                    type: object
                    properties: {}
                  env:
                    description: A list of environment variables to add to a server.
                    type: array
                    items:
                      type: object
                      properties:
                        name:
                          type: string
                        value:
                          type: string
                        valueFrom:
                          type: object
                          properties:
                            secretKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            resourceFieldRef:
                              type: object
                              properties:
                                divisor:
                                  type: string
                                resource:
                                  type: string
                                containerName:
                                  type: string
                            configMapKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            fieldRef:
                              type: object
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                  restartPolicy:
                    description: 'Restart policy for all containers within the pod.
                      One of Always, OnFailure, Never. Default to Always. More info:
                      https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy'
                    type: string
                  nodeSelector:
                    description: Selector which must match a node's labels for the
                      pod to be scheduled on that node.
                    type: object
                    properties: {}
                  volumeMounts:
                    description: Additional volume mounts for the server pod.
                    type: array
                    items:
                      type: object
                      properties:
                        mountPath:
                          type: string
                        mountPropagation:
                          type: string
                        name:
                          type: string
                        readOnly:
                          type: boolean
                        subPath:
                          type: string
                        subPathExpr:
                          type: string
                  labels:
                    description: The labels to be attached to generated resources.
                      The label names must not start with 'weblogic.'.
                    type: object
                    properties: {}
                  runtimeClassName:
                    description: 'RuntimeClassName refers to a RuntimeClass object
                      in the node.k8s.io group, which should be used to run this pod.  If
                      no RuntimeClass resource matches the named class, the pod will
                      not be run. If unset or empty, the "legacy" RuntimeClass will
                      be used, which is an implicit class with an empty definition
                      that uses the default runtime handler. More info: https://github.com/kubernetes/community/blob/master/keps/sig-node/0014-runtime-class.md
                      This is an alpha feature and may change in the future.'
                    type: string
                  tolerations:
                    description: If specified, the pod's tolerations.
                    type: array
                    items:
                      type: object
                      properties:
                        effect:
                          type: string
                        tolerationSeconds:
                          type: number
                        value:
                          type: string
                        key:
                          type: string
                        operator:
                          type: string
                  readinessProbe:
                    description: Settings for the readiness probe associated with
                      a server.
                    type: object
                    properties:
                      periodSeconds:
                        description: The number of seconds between checks.
                        type: number
                      timeoutSeconds:
                        description: The number of seconds with no response that indicates
                          a failure.
                        type: number
                      initialDelaySeconds:
                        description: The number of seconds before the first check
                          is performed.
                        type: number
                  containers:
                    description: Additional containers to be included in the server
                      pod.
                    type: array
                    items:
                      type: object
                      properties:
                        volumeDevices:
                          type: array
                          items:
                            type: object
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        livenessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdin:
                          type: boolean
                        terminationMessagePolicy:
                          type: string
                        terminationMessagePath:
                          type: string
                        workingDir:
                          type: string
                        resources:
                          type: object
                          properties:
                            requests:
                              type: object
                              properties: {}
                            limits:
                              type: object
                              properties: {}
                        securityContext:
                          type: object
                          properties:
                            privileged:
                              type: boolean
                            runAsUser:
                              type: number
                            capabilities:
                              type: object
                              properties:
                                add:
                                  type: array
                                  items:
                                    type: string
                                drop:
                                  type: array
                                  items:
                                    type: string
                            seLinuxOptions:
                              type: object
                              properties:
                                role:
                                  type: string
                                level:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                            procMount:
                              type: string
                            allowPrivilegeEscalation:
                              type: boolean
                            runAsGroup:
                              type: number
                            runAsNonRoot:
                              type: boolean
                            readOnlyRootFilesystem:
                              type: boolean
                        env:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                              valueFrom:
                                type: object
                                properties:
                                  secretKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  configMapKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        ports:
                          type: array
                          items:
                            type: object
                            properties:
                              protocol:
                                type: string
                              hostIP:
                                type: string
                              name:
                                type: string
                              containerPort:
                                type: number
                              hostPort:
                                type: number
                        command:
                          type: array
                          items:
                            type: string
                        volumeMounts:
                          type: array
                          items:
                            type: object
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                        args:
                          type: array
                          items:
                            type: string
                        lifecycle:
                          type: object
                          properties:
                            postStart:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                            preStop:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                        name:
                          type: string
                        tty:
                          type: boolean
                        readinessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdinOnce:
                          type: boolean
                        envFrom:
                          type: array
                          items:
                            type: object
                            properties:
                              configMapRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                              prefix:
                                type: string
                              secretRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                  containerSecurityContext:
                    description: Container-level security attributes. Will override
                      any matching pod-level attributes.
                    type: object
                    properties:
                      privileged:
                        type: boolean
                      runAsUser:
                        type: number
                      capabilities:
                        type: object
                        properties:
                          add:
                            type: array
                            items:
                              type: string
                          drop:
                            type: array
                            items:
                              type: string
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      procMount:
                        type: string
                      allowPrivilegeEscalation:
                        type: boolean
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      readOnlyRootFilesystem:
                        type: boolean
                  schedulerName:
                    description: If specified, the pod will be dispatched by specified
                      scheduler. If not specified, the pod will be dispatched by default
                      scheduler.
                    type: string
                  initContainers:
                    description: Initialization containers to be included in the server
                      pod.
                    type: array
                    items:
                      type: object
                      properties:
                        volumeDevices:
                          type: array
                          items:
                            type: object
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        livenessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdin:
                          type: boolean
                        terminationMessagePolicy:
                          type: string
                        terminationMessagePath:
                          type: string
                        workingDir:
                          type: string
                        resources:
                          type: object
                          properties:
                            requests:
                              type: object
                              properties: {}
                            limits:
                              type: object
                              properties: {}
                        securityContext:
                          type: object
                          properties:
                            privileged:
                              type: boolean
                            runAsUser:
                              type: number
                            capabilities:
                              type: object
                              properties:
                                add:
                                  type: array
                                  items:
                                    type: string
                                drop:
                                  type: array
                                  items:
                                    type: string
                            seLinuxOptions:
                              type: object
                              properties:
                                role:
                                  type: string
                                level:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                            procMount:
                              type: string
                            allowPrivilegeEscalation:
                              type: boolean
                            runAsGroup:
                              type: number
                            runAsNonRoot:
                              type: boolean
                            readOnlyRootFilesystem:
                              type: boolean
                        env:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                              valueFrom:
                                type: object
                                properties:
                                  secretKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  configMapKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        ports:
                          type: array
                          items:
                            type: object
                            properties:
                              protocol:
                                type: string
                              hostIP:
                                type: string
                              name:
                                type: string
                              containerPort:
                                type: number
                              hostPort:
                                type: number
                        command:
                          type: array
                          items:
                            type: string
                        volumeMounts:
                          type: array
                          items:
                            type: object
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                        args:
                          type: array
                          items:
                            type: string
                        lifecycle:
                          type: object
                          properties:
                            postStart:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                            preStop:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                        name:
                          type: string
                        tty:
                          type: boolean
                        readinessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdinOnce:
                          type: boolean
                        envFrom:
                          type: array
                          items:
                            type: object
                            properties:
                              configMapRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                              prefix:
                                type: string
                              secretRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                  shutdown:
                    description: Configures how the operator should shutdown the server
                      instance.
                    type: object
                    properties:
                      ignoreSessions:
                        description: For graceful shutdown only, indicates to ignore
                          pending HTTP sessions during in-flight work handling. Not
                          required. Defaults to false.
                        type: boolean
                      shutdownType:
                        description: Tells the operator how to shutdown server instances.
                          Not required. Defaults to graceful shutdown.
                        type: string
                        enum:
                        - Graceful
                        - Forced
                      timeoutSeconds:
                        description: For graceful shutdown only, number of seconds
                          to wait before aborting in-flight work and shutting down
                          the server. Not required. Defaults to 30 seconds.
                        type: number
                  affinity:
                    description: If specified, the pod's scheduling constraints
                    type: object
                    properties:
                      nodeAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: object
                            properties:
                              nodeSelectorTerms:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchFields:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                preference:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchFields:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                weight:
                                  type: number
                      podAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                labelSelector:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchLabels:
                                      type: object
                                      properties: {}
                                topologyKey:
                                  type: string
                                namespaces:
                                  type: array
                                  items:
                                    type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                podAffinityTerm:
                                  type: object
                                  properties:
                                    labelSelector:
                                      type: object
                                      properties:
                                        matchExpressions:
                                          type: array
                                          items:
                                            type: object
                                            properties:
                                              values:
                                                type: array
                                                items:
                                                  type: string
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                        matchLabels:
                                          type: object
                                          properties: {}
                                    topologyKey:
                                      type: string
                                    namespaces:
                                      type: array
                                      items:
                                        type: string
                                weight:
                                  type: number
                      podAntiAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                labelSelector:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchLabels:
                                      type: object
                                      properties: {}
                                topologyKey:
                                  type: string
                                namespaces:
                                  type: array
                                  items:
                                    type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                podAffinityTerm:
                                  type: object
                                  properties:
                                    labelSelector:
                                      type: object
                                      properties:
                                        matchExpressions:
                                          type: array
                                          items:
                                            type: object
                                            properties:
                                              values:
                                                type: array
                                                items:
                                                  type: string
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                        matchLabels:
                                          type: object
                                          properties: {}
                                    topologyKey:
                                      type: string
                                    namespaces:
                                      type: array
                                      items:
                                        type: string
                                weight:
                                  type: number
              serverStartPolicy:
                description: The strategy for deciding whether to start a server.
                  Legal values are ALWAYS, NEVER, or IF_NEEDED.
                type: string
                enum:
                - ALWAYS
                - NEVER
                - IF_NEEDED
              restartVersion:
                description: If present, every time this value is updated the operator
                  will restart the required servers.
                type: string
            required:
            - serverName
        clusters:
          type: array
          description: Configuration for the clusters.
          items:
            description: An element representing a cluster in the domain configuration.
            type: object
            properties:
              serverStartState:
                description: The state in which the server is to be started. Use ADMIN
                  if server should start in the admin state. Defaults to RUNNING.
                type: string
                enum:
                - RUNNING
                - ADMIN
              serverService:
                description: Customization affecting ClusterIP Kubernetes services
                  for WebLogic Server instances.
                type: object
                properties:
                  precreateService:
                    description: If true, operator will create server services even
                      for server instances without running pods.
                    type: boolean
                  annotations:
                    description: The annotations to be attached to generated resources.
                    type: object
                    properties: {}
                  labels:
                    description: The labels to be attached to generated resources.
                      The label names must not start with 'weblogic.'.
                    type: object
                    properties: {}
              maxUnavailable:
                description: The maximum number of cluster members that can be temporarily
                  unavailable. Defaults to 1.
                type: number
                minimum: 1.0
              replicas:
                description: The number of cluster members to run.
                type: number
                minimum: 0.0
              clusterName:
                description: The name of this cluster. Required
                type: string
              serverPod:
                description: Configuration affecting server pods.
                type: object
                properties:
                  nodeName:
                    description: NodeName is a request to schedule this pod onto a
                      specific node. If it is non-empty, the scheduler simply schedules
                      this pod onto that node, assuming that it fits resource requirements.
                    type: string
                  livenessProbe:
                    description: Settings for the liveness probe associated with a
                      server.
                    type: object
                    properties:
                      periodSeconds:
                        description: The number of seconds between checks.
                        type: number
                      timeoutSeconds:
                        description: The number of seconds with no response that indicates
                          a failure.
                        type: number
                      initialDelaySeconds:
                        description: The number of seconds before the first check
                          is performed.
                        type: number
                  readinessGates:
                    description: 'If specified, all readiness gates will be evaluated
                      for pod readiness. A pod is ready when all its containers are
                      ready AND all conditions specified in the readiness gates have
                      status equal to "True" More info: https://github.com/kubernetes/community/blob/master/keps/sig-network/0007-pod-ready%2B%2B.md'
                    type: array
                    items:
                      type: object
                      properties:
                        conditionType:
                          type: string
                  serviceAccountName:
                    description: Name of the ServiceAccount to be used to run this
                      pod. If it is not set, default ServiceAccount will be used.
                      The ServiceAccount has to exist at the time the pod is created.
                    type: string
                  podSecurityContext:
                    description: Pod-level security attributes.
                    type: object
                    properties:
                      runAsUser:
                        type: number
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      fsGroup:
                        type: number
                      supplementalGroups:
                        type: array
                        items:
                          type: number
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      sysctls:
                        type: array
                        items:
                          type: object
                          properties:
                            name:
                              type: string
                            value:
                              type: string
                  priorityClassName:
                    description: If specified, indicates the pod's priority. "system-node-critical"
                      and "system-cluster-critical" are two special keywords which
                      indicate the highest priorities with the former being the highest
                      priority. Any other name must be defined by creating a PriorityClass
                      object with that name. If not specified, the pod priority will
                      be default or zero if there is no default.
                    type: string
                  volumes:
                    description: Additional volumes to be created in the server pod.
                    type: array
                    items:
                      type: object
                      properties:
                        quobyte:
                          type: object
                          properties:
                            volume:
                              type: string
                            registry:
                              type: string
                            readOnly:
                              type: boolean
                            user:
                              type: string
                            tenant:
                              type: string
                            group:
                              type: string
                        azureFile:
                          type: object
                          properties:
                            secretName:
                              type: string
                            readOnly:
                              type: boolean
                            shareName:
                              type: string
                        flexVolume:
                          type: object
                          properties:
                            driver:
                              type: string
                            options:
                              type: object
                              properties: {}
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        secret:
                          type: object
                          properties:
                            secretName:
                              type: string
                            defaultMode:
                              type: number
                            optional:
                              type: boolean
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  key:
                                    type: string
                        projected:
                          type: object
                          properties:
                            sources:
                              type: array
                              items:
                                type: object
                                properties:
                                  downwardAPI:
                                    type: object
                                    properties:
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            resourceFieldRef:
                                              type: object
                                              properties:
                                                divisor:
                                                  type: string
                                                resource:
                                                  type: string
                                                containerName:
                                                  type: string
                                            fieldRef:
                                              type: object
                                              properties:
                                                apiVersion:
                                                  type: string
                                                fieldPath:
                                                  type: string
                                  configMap:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            key:
                                              type: string
                                  secret:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      items:
                                        type: array
                                        items:
                                          type: object
                                          properties:
                                            mode:
                                              type: number
                                            path:
                                              type: string
                                            key:
                                              type: string
                                  serviceAccountToken:
                                    type: object
                                    properties:
                                      path:
                                        type: string
                                      audience:
                                        type: string
                                      expirationSeconds:
                                        type: number
                            defaultMode:
                              type: number
                        cephfs:
                          type: object
                          properties:
                            path:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            secretFile:
                              type: string
                            readOnly:
                              type: boolean
                            user:
                              type: string
                            monitors:
                              type: array
                              items:
                                type: string
                        scaleIO:
                          type: object
                          properties:
                            system:
                              type: string
                            protectionDomain:
                              type: string
                            sslEnabled:
                              type: boolean
                            storageMode:
                              type: string
                            volumeName:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            storagePool:
                              type: string
                            gateway:
                              type: string
                        emptyDir:
                          type: object
                          properties:
                            sizeLimit:
                              type: string
                            medium:
                              type: string
                        glusterfs:
                          type: object
                          properties:
                            path:
                              type: string
                            endpoints:
                              type: string
                            readOnly:
                              type: boolean
                        gcePersistentDisk:
                          type: object
                          properties:
                            partition:
                              type: number
                            readOnly:
                              type: boolean
                            pdName:
                              type: string
                            fsType:
                              type: string
                        photonPersistentDisk:
                          type: object
                          properties:
                            pdID:
                              type: string
                            fsType:
                              type: string
                        azureDisk:
                          type: object
                          properties:
                            diskName:
                              type: string
                            kind:
                              type: string
                            readOnly:
                              type: boolean
                            cachingMode:
                              type: string
                            diskURI:
                              type: string
                            fsType:
                              type: string
                        cinder:
                          type: object
                          properties:
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        downwardAPI:
                          type: object
                          properties:
                            defaultMode:
                              type: number
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        awsElasticBlockStore:
                          type: object
                          properties:
                            partition:
                              type: number
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        flocker:
                          type: object
                          properties:
                            datasetName:
                              type: string
                            datasetUUID:
                              type: string
                        iscsi:
                          type: object
                          properties:
                            chapAuthSession:
                              type: boolean
                            iscsiInterface:
                              type: string
                            lun:
                              type: number
                            chapAuthDiscovery:
                              type: boolean
                            iqn:
                              type: string
                            portals:
                              type: array
                              items:
                                type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            initiatorName:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            targetPortal:
                              type: string
                        rbd:
                          type: object
                          properties:
                            image:
                              type: string
                            pool:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            keyring:
                              type: string
                            user:
                              type: string
                            monitors:
                              type: array
                              items:
                                type: string
                        configMap:
                          type: object
                          properties:
                            defaultMode:
                              type: number
                            name:
                              type: string
                            optional:
                              type: boolean
                            items:
                              type: array
                              items:
                                type: object
                                properties:
                                  mode:
                                    type: number
                                  path:
                                    type: string
                                  key:
                                    type: string
                        storageos:
                          type: object
                          properties:
                            volumeNamespace:
                              type: string
                            volumeName:
                              type: string
                            secretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        csi:
                          type: object
                          properties:
                            driver:
                              type: string
                            nodePublishSecretRef:
                              type: object
                              properties:
                                name:
                                  type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                            volumeAttributes:
                              type: object
                              properties: {}
                        name:
                          type: string
                        nfs:
                          type: object
                          properties:
                            path:
                              type: string
                            server:
                              type: string
                            readOnly:
                              type: boolean
                        persistentVolumeClaim:
                          type: object
                          properties:
                            claimName:
                              type: string
                            readOnly:
                              type: boolean
                        gitRepo:
                          type: object
                          properties:
                            repository:
                              type: string
                            directory:
                              type: string
                            revision:
                              type: string
                        portworxVolume:
                          type: object
                          properties:
                            volumeID:
                              type: string
                            readOnly:
                              type: boolean
                            fsType:
                              type: string
                        vsphereVolume:
                          type: object
                          properties:
                            storagePolicyName:
                              type: string
                            storagePolicyID:
                              type: string
                            volumePath:
                              type: string
                            fsType:
                              type: string
                        fc:
                          type: object
                          properties:
                            lun:
                              type: number
                            targetWWNs:
                              type: array
                              items:
                                type: string
                            readOnly:
                              type: boolean
                            wwids:
                              type: array
                              items:
                                type: string
                            fsType:
                              type: string
                        hostPath:
                          type: object
                          properties:
                            path:
                              type: string
                            type:
                              type: string
                  resources:
                    description: Memory and CPU minimum requirements and limits for
                      the server.
                    type: object
                    properties:
                      requests:
                        type: object
                        properties: {}
                      limits:
                        type: object
                        properties: {}
                  annotations:
                    description: The annotations to be attached to generated resources.
                    type: object
                    properties: {}
                  env:
                    description: A list of environment variables to add to a server.
                    type: array
                    items:
                      type: object
                      properties:
                        name:
                          type: string
                        value:
                          type: string
                        valueFrom:
                          type: object
                          properties:
                            secretKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            resourceFieldRef:
                              type: object
                              properties:
                                divisor:
                                  type: string
                                resource:
                                  type: string
                                containerName:
                                  type: string
                            configMapKeyRef:
                              type: object
                              properties:
                                name:
                                  type: string
                                optional:
                                  type: boolean
                                key:
                                  type: string
                            fieldRef:
                              type: object
                              properties:
                                apiVersion:
                                  type: string
                                fieldPath:
                                  type: string
                  restartPolicy:
                    description: 'Restart policy for all containers within the pod.
                      One of Always, OnFailure, Never. Default to Always. More info:
                      https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy'
                    type: string
                  nodeSelector:
                    description: Selector which must match a node's labels for the
                      pod to be scheduled on that node.
                    type: object
                    properties: {}
                  volumeMounts:
                    description: Additional volume mounts for the server pod.
                    type: array
                    items:
                      type: object
                      properties:
                        mountPath:
                          type: string
                        mountPropagation:
                          type: string
                        name:
                          type: string
                        readOnly:
                          type: boolean
                        subPath:
                          type: string
                        subPathExpr:
                          type: string
                  labels:
                    description: The labels to be attached to generated resources.
                      The label names must not start with 'weblogic.'.
                    type: object
                    properties: {}
                  runtimeClassName:
                    description: 'RuntimeClassName refers to a RuntimeClass object
                      in the node.k8s.io group, which should be used to run this pod.  If
                      no RuntimeClass resource matches the named class, the pod will
                      not be run. If unset or empty, the "legacy" RuntimeClass will
                      be used, which is an implicit class with an empty definition
                      that uses the default runtime handler. More info: https://github.com/kubernetes/community/blob/master/keps/sig-node/0014-runtime-class.md
                      This is an alpha feature and may change in the future.'
                    type: string
                  tolerations:
                    description: If specified, the pod's tolerations.
                    type: array
                    items:
                      type: object
                      properties:
                        effect:
                          type: string
                        tolerationSeconds:
                          type: number
                        value:
                          type: string
                        key:
                          type: string
                        operator:
                          type: string
                  readinessProbe:
                    description: Settings for the readiness probe associated with
                      a server.
                    type: object
                    properties:
                      periodSeconds:
                        description: The number of seconds between checks.
                        type: number
                      timeoutSeconds:
                        description: The number of seconds with no response that indicates
                          a failure.
                        type: number
                      initialDelaySeconds:
                        description: The number of seconds before the first check
                          is performed.
                        type: number
                  containers:
                    description: Additional containers to be included in the server
                      pod.
                    type: array
                    items:
                      type: object
                      properties:
                        volumeDevices:
                          type: array
                          items:
                            type: object
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        livenessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdin:
                          type: boolean
                        terminationMessagePolicy:
                          type: string
                        terminationMessagePath:
                          type: string
                        workingDir:
                          type: string
                        resources:
                          type: object
                          properties:
                            requests:
                              type: object
                              properties: {}
                            limits:
                              type: object
                              properties: {}
                        securityContext:
                          type: object
                          properties:
                            privileged:
                              type: boolean
                            runAsUser:
                              type: number
                            capabilities:
                              type: object
                              properties:
                                add:
                                  type: array
                                  items:
                                    type: string
                                drop:
                                  type: array
                                  items:
                                    type: string
                            seLinuxOptions:
                              type: object
                              properties:
                                role:
                                  type: string
                                level:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                            procMount:
                              type: string
                            allowPrivilegeEscalation:
                              type: boolean
                            runAsGroup:
                              type: number
                            runAsNonRoot:
                              type: boolean
                            readOnlyRootFilesystem:
                              type: boolean
                        env:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                              valueFrom:
                                type: object
                                properties:
                                  secretKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  configMapKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        ports:
                          type: array
                          items:
                            type: object
                            properties:
                              protocol:
                                type: string
                              hostIP:
                                type: string
                              name:
                                type: string
                              containerPort:
                                type: number
                              hostPort:
                                type: number
                        command:
                          type: array
                          items:
                            type: string
                        volumeMounts:
                          type: array
                          items:
                            type: object
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                        args:
                          type: array
                          items:
                            type: string
                        lifecycle:
                          type: object
                          properties:
                            postStart:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                            preStop:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                        name:
                          type: string
                        tty:
                          type: boolean
                        readinessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdinOnce:
                          type: boolean
                        envFrom:
                          type: array
                          items:
                            type: object
                            properties:
                              configMapRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                              prefix:
                                type: string
                              secretRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                  containerSecurityContext:
                    description: Container-level security attributes. Will override
                      any matching pod-level attributes.
                    type: object
                    properties:
                      privileged:
                        type: boolean
                      runAsUser:
                        type: number
                      capabilities:
                        type: object
                        properties:
                          add:
                            type: array
                            items:
                              type: string
                          drop:
                            type: array
                            items:
                              type: string
                      seLinuxOptions:
                        type: object
                        properties:
                          role:
                            type: string
                          level:
                            type: string
                          type:
                            type: string
                          user:
                            type: string
                      procMount:
                        type: string
                      allowPrivilegeEscalation:
                        type: boolean
                      runAsGroup:
                        type: number
                      runAsNonRoot:
                        type: boolean
                      readOnlyRootFilesystem:
                        type: boolean
                  schedulerName:
                    description: If specified, the pod will be dispatched by specified
                      scheduler. If not specified, the pod will be dispatched by default
                      scheduler.
                    type: string
                  initContainers:
                    description: Initialization containers to be included in the server
                      pod.
                    type: array
                    items:
                      type: object
                      properties:
                        volumeDevices:
                          type: array
                          items:
                            type: object
                            properties:
                              devicePath:
                                type: string
                              name:
                                type: string
                        image:
                          type: string
                        imagePullPolicy:
                          type: string
                        livenessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdin:
                          type: boolean
                        terminationMessagePolicy:
                          type: string
                        terminationMessagePath:
                          type: string
                        workingDir:
                          type: string
                        resources:
                          type: object
                          properties:
                            requests:
                              type: object
                              properties: {}
                            limits:
                              type: object
                              properties: {}
                        securityContext:
                          type: object
                          properties:
                            privileged:
                              type: boolean
                            runAsUser:
                              type: number
                            capabilities:
                              type: object
                              properties:
                                add:
                                  type: array
                                  items:
                                    type: string
                                drop:
                                  type: array
                                  items:
                                    type: string
                            seLinuxOptions:
                              type: object
                              properties:
                                role:
                                  type: string
                                level:
                                  type: string
                                type:
                                  type: string
                                user:
                                  type: string
                            procMount:
                              type: string
                            allowPrivilegeEscalation:
                              type: boolean
                            runAsGroup:
                              type: number
                            runAsNonRoot:
                              type: boolean
                            readOnlyRootFilesystem:
                              type: boolean
                        env:
                          type: array
                          items:
                            type: object
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                              valueFrom:
                                type: object
                                properties:
                                  secretKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  resourceFieldRef:
                                    type: object
                                    properties:
                                      divisor:
                                        type: string
                                      resource:
                                        type: string
                                      containerName:
                                        type: string
                                  configMapKeyRef:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      optional:
                                        type: boolean
                                      key:
                                        type: string
                                  fieldRef:
                                    type: object
                                    properties:
                                      apiVersion:
                                        type: string
                                      fieldPath:
                                        type: string
                        ports:
                          type: array
                          items:
                            type: object
                            properties:
                              protocol:
                                type: string
                              hostIP:
                                type: string
                              name:
                                type: string
                              containerPort:
                                type: number
                              hostPort:
                                type: number
                        command:
                          type: array
                          items:
                            type: string
                        volumeMounts:
                          type: array
                          items:
                            type: object
                            properties:
                              mountPath:
                                type: string
                              mountPropagation:
                                type: string
                              name:
                                type: string
                              readOnly:
                                type: boolean
                              subPath:
                                type: string
                              subPathExpr:
                                type: string
                        args:
                          type: array
                          items:
                            type: string
                        lifecycle:
                          type: object
                          properties:
                            postStart:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                            preStop:
                              type: object
                              properties:
                                tcpSocket:
                                  type: object
                                  properties:
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                exec:
                                  type: object
                                  properties:
                                    command:
                                      type: array
                                      items:
                                        type: string
                                httpGet:
                                  type: object
                                  properties:
                                    path:
                                      type: string
                                    scheme:
                                      type: string
                                    port:
                                      type: object
                                      properties:
                                        intValue:
                                          type: number
                                        isInt:
                                          type: boolean
                                        strValue:
                                          type: string
                                      required:
                                      - isInt
                                    host:
                                      type: string
                                    httpHeaders:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          name:
                                            type: string
                                          value:
                                            type: string
                        name:
                          type: string
                        tty:
                          type: boolean
                        readinessProbe:
                          type: object
                          properties:
                            failureThreshold:
                              type: number
                            periodSeconds:
                              type: number
                            tcpSocket:
                              type: object
                              properties:
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                            timeoutSeconds:
                              type: number
                            successThreshold:
                              type: number
                            initialDelaySeconds:
                              type: number
                            exec:
                              type: object
                              properties:
                                command:
                                  type: array
                                  items:
                                    type: string
                            httpGet:
                              type: object
                              properties:
                                path:
                                  type: string
                                scheme:
                                  type: string
                                port:
                                  type: object
                                  properties:
                                    intValue:
                                      type: number
                                    isInt:
                                      type: boolean
                                    strValue:
                                      type: string
                                  required:
                                  - isInt
                                host:
                                  type: string
                                httpHeaders:
                                  type: array
                                  items:
                                    type: object
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                        stdinOnce:
                          type: boolean
                        envFrom:
                          type: array
                          items:
                            type: object
                            properties:
                              configMapRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                              prefix:
                                type: string
                              secretRef:
                                type: object
                                properties:
                                  name:
                                    type: string
                                  optional:
                                    type: boolean
                  shutdown:
                    description: Configures how the operator should shutdown the server
                      instance.
                    type: object
                    properties:
                      ignoreSessions:
                        description: For graceful shutdown only, indicates to ignore
                          pending HTTP sessions during in-flight work handling. Not
                          required. Defaults to false.
                        type: boolean
                      shutdownType:
                        description: Tells the operator how to shutdown server instances.
                          Not required. Defaults to graceful shutdown.
                        type: string
                        enum:
                        - Graceful
                        - Forced
                      timeoutSeconds:
                        description: For graceful shutdown only, number of seconds
                          to wait before aborting in-flight work and shutting down
                          the server. Not required. Defaults to 30 seconds.
                        type: number
                  affinity:
                    description: If specified, the pod's scheduling constraints
                    type: object
                    properties:
                      nodeAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: object
                            properties:
                              nodeSelectorTerms:
                                type: array
                                items:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchFields:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                preference:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchFields:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                weight:
                                  type: number
                      podAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                labelSelector:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchLabels:
                                      type: object
                                      properties: {}
                                topologyKey:
                                  type: string
                                namespaces:
                                  type: array
                                  items:
                                    type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                podAffinityTerm:
                                  type: object
                                  properties:
                                    labelSelector:
                                      type: object
                                      properties:
                                        matchExpressions:
                                          type: array
                                          items:
                                            type: object
                                            properties:
                                              values:
                                                type: array
                                                items:
                                                  type: string
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                        matchLabels:
                                          type: object
                                          properties: {}
                                    topologyKey:
                                      type: string
                                    namespaces:
                                      type: array
                                      items:
                                        type: string
                                weight:
                                  type: number
                      podAntiAffinity:
                        type: object
                        properties:
                          requiredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                labelSelector:
                                  type: object
                                  properties:
                                    matchExpressions:
                                      type: array
                                      items:
                                        type: object
                                        properties:
                                          values:
                                            type: array
                                            items:
                                              type: string
                                          key:
                                            type: string
                                          operator:
                                            type: string
                                    matchLabels:
                                      type: object
                                      properties: {}
                                topologyKey:
                                  type: string
                                namespaces:
                                  type: array
                                  items:
                                    type: string
                          preferredDuringSchedulingIgnoredDuringExecution:
                            type: array
                            items:
                              type: object
                              properties:
                                podAffinityTerm:
                                  type: object
                                  properties:
                                    labelSelector:
                                      type: object
                                      properties:
                                        matchExpressions:
                                          type: array
                                          items:
                                            type: object
                                            properties:
                                              values:
                                                type: array
                                                items:
                                                  type: string
                                              key:
                                                type: string
                                              operator:
                                                type: string
                                        matchLabels:
                                          type: object
                                          properties: {}
                                    topologyKey:
                                      type: string
                                    namespaces:
                                      type: array
                                      items:
                                        type: string
                                weight:
                                  type: number
              clusterService:
                description: Customization affecting ClusterIP Kubernetes services
                  for the WebLogic cluster.
                type: object
                properties:
                  annotations:
                    description: The annotations to be attached to generated resources.
                    type: object
                    properties: {}
                  labels:
                    description: The labels to be attached to generated resources.
                      The label names must not start with 'weblogic.'.
                    type: object
                    properties: {}
              serverStartPolicy:
                description: The strategy for deciding whether to start a server.
                  Legal values are NEVER, or IF_NEEDED.
                type: string
                enum:
                - NEVER
                - IF_NEEDED
              restartVersion:
                description: If present, every time this value is updated the operator
                  will restart the required servers.
                type: string
            required:
            - clusterName
    status:
      type: object
      description: DomainStatus represents information about the status of a domain.
        Status may trail the actual state of a system.
      properties:
        reason:
          type: string
          description: A brief CamelCase message indicating details about why the
            domain is in this state.
        servers:
          type: array
          description: Status of WebLogic Servers in this domain.
          items:
            type: object
            properties:
              nodeName:
                description: Name of node that is hosting the Pod containing this
                  WebLogic Server.
                type: string
              clusterName:
                description: WebLogic cluster name, if the server is part of a cluster.
                type: string
              serverName:
                description: WebLogic Server name. Required.
                type: string
              health:
                description: Current status and health of a specific WebLogic Server.
                type: object
                properties:
                  overallHealth:
                    description: Server health of this WebLogic Server. If the value
                      is "Not available", the operator has failed to read the health.
                      If the value is "Not available (possibly overloaded)", the operator
                      has failed to read the health of the server possibly due to
                      the server is in overloaded state.
                    type: string
                  activationTime:
                    format: date-time
                    description: RFC 3339 date and time at which the server started.
                    type: string
                  subsystems:
                    description: Status of unhealthy subsystems, if any.
                    type: array
                    items:
                      type: object
                      properties:
                        symptoms:
                          description: Symptoms provided by the reporting subsystem.
                          type: array
                          items:
                            type: string
                        health:
                          description: Server health of this WebLogic Server. Required.
                          type: string
                        subsystemName:
                          description: Name of subsystem providing symptom information.
                            Required.
                          type: string
              state:
                description: Current state of this WebLogic Server. Required.
                type: string
        replicas:
          type: number
          description: The number of running Managed Servers in the WebLogic cluster
            if there is only one cluster in the domain and where the cluster does
            not explicitly configure its replicas in a cluster specification.
          minimum: 0.0
        startTime:
          type: string
          description: RFC 3339 date and time at which the operator started the domain.
            This will be when the operator begins processing and will precede when
            the various servers or clusters are available.
          format: date-time
        conditions:
          type: array
          description: Current service state of domain.
          items:
            type: object
            properties:
              reason:
                description: Unique, one-word, CamelCase reason for the condition's
                  last transition.
                type: string
              type:
                description: The type of the condition. Valid types are Progressing,
                  Available, and Failed. Required.
                type: string
                enum:
                - Progressing
                - Available
                - Failed
              lastTransitionTime:
                format: date-time
                description: Last time the condition transitioned from one status
                  to another.
                type: string
              message:
                description: Human-readable message indicating details about last
                  transition.
                type: string
              lastProbeTime:
                format: date-time
                description: Last time we probed the condition.
                type: string
              status:
                description: Status is the status of the condition. Can be True, False,
                  Unknown. Required.
                type: string
        message:
          type: string
          description: A human readable message indicating details about why the domain
            is in this condition.
        clusters:
          type: array
          description: Status of WebLogic clusters in this domain.
          items:
            type: object
            properties:
              maximumReplicas:
                description: The maximum number of cluster members. Required.
                type: number
                minimum: 0.0
              replicas:
                description: The number of intended cluster members. Required.
                type: number
                minimum: 0.0
              clusterName:
                description: WebLogic cluster name. Required.
                type: string
              readyReplicas:
                description: The number of ready cluster members. Required.
                type: number
                minimum: 0.0
{{- end}}