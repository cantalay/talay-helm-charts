# talay-helm-charts

Talay uygulamalarının ortak Kubernetes sözleşmesidir.

| Chart | Kullanım |
| --- | --- |
| `talay-service` | Spring Boot/Java veya Node HTTP API |
| `talay-web` | React, Vite ve Expo Web statik uygulaması |
| `talay-common` | Paylaşılan Helm library helper'ları |

Native React Native Android/iOS uygulamaları Kubernetes'e deploy edilmez; build/sign/store dağıtımı `talay-workflows` EAS iş akışıyla yapılır. Backend ve web workload'ları OTLP endpoint, resource attributes, probes, ExternalSecret, autoscaling, PDB, NetworkPolicy ve ServiceMonitor sözleşmelerini bu chartlardan alır. Yeni bir workload türü gerçekten kullanılmaya başladığında ayrı ve test edilen bir chart olarak eklenir.

Java auto-instrumentation etkinleştirildiğinde pinned OpenTelemetry Java agent `2.31.1` bir init container ile kopyalanır. Node auto-instrumentation için uygulamanın `@opentelemetry/auto-instrumentations-node` paketini production dependency olarak içermesi gerekir.

Private registry kullanan servislerde `registrySecret.enabled=true` yapılır. Chart, `platform/registry/ghcr` benzeri Vault KV yolundaki `.dockerconfigjson` alanını `kubernetes.io/dockerconfigjson` tipinde namespace-local `ghcr-pull` Secret'ına dönüştürür ve pod'a otomatik bağlar. Registry parolası values veya Git reposuna yazılmaz.

`talay-service` için aynı-namespace ingress kapatılabilir ve egress kuralları açık allowlist olarak verilebilir. `talay-web` statik workload'ları egress'i tamamen kapatabilir. Uygulamaya özel NGINX dosyası environment reposunda tutulur ve `nginx.existingConfigMap` ile bağlanır; `nginx.configRevision` değişikliği kontrollü rollout başlatır. Helm test podları ile OpenTelemetry init container'ı read-only root filesystem, non-root ve RuntimeDefault seccomp ile çalışır; yardımcı ve agent image'ları digest ile sabittir.

Library dependency'leri release/lint öncesinde `helm dependency build charts/<chart>` ile çözülür. Chart'lar OCI registry'ye immutable sürümle publish edilmelidir; environment reposu major sürümü otomatik ilerletmemelidir.
