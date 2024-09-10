#!/usr/bin/env bash

# find . -type f -name "*.purs"

function update {
  file="$1"
  thisrepo="$HOME/projects/purescript-halogen-nextjs/packages/client-halogen-examples"
  homerepo="$HOME/projects/purescript-halogen/examples"

  rm -f $thisrepo/$file
  cp $homerepo/$file $thisrepo/$file
}

update lifecycle/src/Child.purs
update lifecycle/src/Main.purs
update higher-order-components/src/Main.purs
update higher-order-components/src/Harness.purs
update higher-order-components/src/Panel.purs
update higher-order-components/src/Button.purs
update components-multitype/src/Container.purs
update components-multitype/src/ComponentB.purs
update components-multitype/src/Main.purs
update components-multitype/src/ComponentC.purs
update components-multitype/src/ComponentA.purs
update basic/src/Button.purs
update components-inputs/src/Container.purs
update components-inputs/src/Display.purs
update ace/src/Container.purs
update ace/src/AceComponent.purs
update keyboard-input/src/Main.purs
update components/src/Container.purs
update components/src/Main.purs
update components/src/Button.purs
update effects-effect-random/src/Component.purs
update effects-effect-random/src/Main.purs
update effects-aff-ajax/src/Component.purs
update effects-aff-ajax/src/Main.purs
update interpret/src/Main.purs
