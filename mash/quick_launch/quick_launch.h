// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef MASH_QUICK_LAUNCH_QUICK_LAUNCH_H_
#define MASH_QUICK_LAUNCH_QUICK_LAUNCH_H_

#include <memory>

#include "base/macros.h"
#include "mash/public/interfaces/launchable.mojom.h"
#include "mojo/public/cpp/bindings/binding_set.h"
#include "services/service_manager/public/cpp/interface_factory.h"
#include "services/service_manager/public/cpp/service.h"
#include "services/tracing/public/cpp/provider.h"

namespace views {
class AuraInit;
class Widget;
}

namespace mash {
namespace quick_launch {

class QuickLaunch
    : public service_manager::Service,
      public ::mash::mojom::Launchable,
      public service_manager::InterfaceFactory<::mash::mojom::Launchable> {
 public:
  QuickLaunch();
  ~QuickLaunch() override;

  void RemoveWindow(views::Widget* window);

 private:
  // service_manager::Service:
  void OnStart() override;
  bool OnConnect(const service_manager::ServiceInfo& remote_info,
                 service_manager::InterfaceRegistry* registry) override;

  // ::mash::mojom::Launchable:
  void Launch(uint32_t what, ::mash::mojom::LaunchMode how) override;

  // service_manager::InterfaceFactory<::mash::mojom::Launchable>:
  void Create(const service_manager::Identity& remote_identity,
              ::mash::mojom::LaunchableRequest request) override;

  mojo::BindingSet<::mash::mojom::Launchable> bindings_;
  std::vector<views::Widget*> windows_;

  tracing::Provider tracing_;
  std::unique_ptr<views::AuraInit> aura_init_;

  DISALLOW_COPY_AND_ASSIGN(QuickLaunch);
};

}  // namespace quick_launch
}  // namespace mash

#endif  // MASH_QUICK_LAUNCH_QUICK_LAUNCH_H_
