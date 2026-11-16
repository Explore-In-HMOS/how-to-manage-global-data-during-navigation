import { describe, beforeAll, afterEach, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

const STEP: number = 500;
const SETTLE_MS: number = 1500;

async function readGoal(driver: Driver): Promise<number> {
  const label = await driver.waitForComponent(ON.id('goalValue'), 3000);
  return Number.parseInt(await label.getText());
}

const MAX_SWIPES: number = 12;

async function tap(driver: Driver, id: string): Promise<void> {
  const size = await driver.getDisplaySize();
  const cx = Math.round(size.x / 2);
  const bandTop = size.y * 0.25;
  const bandBottom = size.y * 0.75;
  const nudge = Math.round(size.y * 0.25);
  await driver.waitForComponent(ON.id(id), 1000);
  for (let i = 0; i < MAX_SWIPES; i++) {
    const component = await driver.findComponent(ON.id(id));
    let swipeUp = i < MAX_SWIPES / 2;
    if (component !== null) {
      const bounds = await component.getBounds();
      const cy = (bounds.top + bounds.bottom) / 2;
      if (cy >= bandTop && cy <= bandBottom) {
        await component.click();
        await driver.delayMs(SETTLE_MS);
        return;
      }
      swipeUp = cy > bandBottom;
    }
    const from = Math.round(size.y / 2);
    await driver.swipe(cx, from, cx, swipeUp ? from - nudge : from + nudge, 800);
    await driver.delayMs(500);
  }
  throw new Error(`Component "${id}" not brought on screen after ${MAX_SWIPES} swipes`);
}

async function returnHome(driver: Driver): Promise<void> {
  for (let i = 0; i < 5; i++) {
    if (await driver.findComponent(ON.id('homeMenu')) !== null) {
      return;
    }
    await driver.pressBack();
    await driver.delayMs(SETTLE_MS);
  }
}

async function runFlow(driver: Driver, menuId: string, viaConfirm: boolean): Promise<number[]> {
  await tap(driver, menuId);
  const before = await readGoal(driver);
  await tap(driver, 'editBtn');
  await tap(driver, 'plusBtn');
  if (viaConfirm) {
    await tap(driver, 'nextBtn');
    await tap(driver, 'confirmSaveBtn');
  } else {
    await tap(driver, 'saveBtn');
  }
  const after = await readGoal(driver);
  await driver.pressBack();
  await driver.delayMs(SETTLE_MS);
  return [before, after];
}

export default function navSyncFlowTest() {
  describe('NavSyncFlow', () => {
    const driver: Driver = Driver.create();

    beforeAll(async () => {
      const delegator = abilityDelegatorRegistry.getAbilityDelegator();
      const want: Want = {
        bundleName: abilityDelegatorRegistry.getArguments().bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await driver.delayMs(2000);
    });

    afterEach(async () => {
      await returnHome(driver);
    });

    it('approach1_broken_showsStaleValue', 0, async () => {
      const result = await runFlow(driver, 'menuBroken', false);
      expect(result[1]).assertEqual(result[0]);
    });

    it('approach2_appStorage_showsNewValue', 0, async () => {
      const result = await runFlow(driver, 'menuAppStorage', false);
      expect(result[1]).assertEqual(result[0] + STEP);
    });

    it('approach3_popResult_showsNewValue', 0, async () => {
      const result = await runFlow(driver, 'menuPopResult', false);
      expect(result[1]).assertEqual(result[0] + STEP);
    });

    it('approach3_popToNameViaConfirm_showsNewValue', 0, async () => {
      const result = await runFlow(driver, 'menuPopResult', true);
      expect(result[1]).assertEqual(result[0] + STEP);
    });

    it('approach4_routeManager_showsNewValue', 0, async () => {
      const result = await runFlow(driver, 'menuRouteManager', false);
      expect(result[1]).assertEqual(result[0] + STEP);
    });

    it('approach4_backToViaConfirm_showsNewValue', 0, async () => {
      const result = await runFlow(driver, 'menuRouteManager', true);
      expect(result[1]).assertEqual(result[0] + STEP);
    });
  });
}
