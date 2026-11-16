import { describe, beforeEach, it, expect } from '@ohos/hypium';
import { ResultListener, RouteCore, StackLike } from '../main/ets/common/RouteCore';

const KEY: string = 'goal';

class FakeStack implements StackLike {
  calls: string[] = [];
  probe: (() => Object | undefined) | undefined = undefined;
  seenAtPop: Object | undefined = undefined;

  push(name: string, param?: Object): void {
    this.calls.push(`push:${name}:${param ?? ''}`);
  }

  pop(): void {
    this.seenAtPop = this.probe !== undefined ? this.probe() : undefined;
    this.calls.push('pop');
  }

  popToName(name: string): void {
    this.seenAtPop = this.probe !== undefined ? this.probe() : undefined;
    this.calls.push(`popToName:${name}`);
  }
}

export default function routeCoreTest() {
  describe('RouteCore', () => {
    let stack: FakeStack = new FakeStack();
    let core: RouteCore = new RouteCore(stack);

    beforeEach(() => {
      stack = new FakeStack();
      core = new RouteCore(stack);
      stack.probe = () => core.getResult(KEY);
    });

    it('back_commitsResultBeforePop', 0, () => {
      core.back(KEY, 9000);
      expect(stack.seenAtPop).assertEqual(9000);
      expect(stack.calls.join(',')).assertEqual('pop');
    });

    it('back_notifiesListenersBeforePop', 0, () => {
      const order: string[] = [];
      core.onResult(KEY, (value: Object) => {
        order.push(`listener:${value}`);
      });
      stack.probe = () => {
        order.push('pop');
        return core.getResult(KEY);
      };
      core.back(KEY, 8500);
      expect(order.join(',')).assertEqual('listener:8500,pop');
    });

    it('backTo_commitsResultBeforePopToName', 0, () => {
      core.backTo('DashboardRM', KEY, 12000);
      expect(stack.seenAtPop).assertEqual(12000);
      expect(stack.calls.join(',')).assertEqual('popToName:DashboardRM');
    });

    it('back_withoutResult_leavesStoreUntouched', 0, () => {
      core.setResult(KEY, 7000);
      core.back();
      expect(core.getResult(KEY)).assertEqual(7000);
      expect(stack.calls.join(',')).assertEqual('pop');
    });

    it('offResult_removesListener', 0, () => {
      let calls = 0;
      const listener: ResultListener = () => {
        calls++;
      };
      core.onResult(KEY, listener);
      core.setResult(KEY, 1);
      core.offResult(KEY, listener);
      core.setResult(KEY, 2);
      expect(calls).assertEqual(1);
      expect(core.listenerCount(KEY)).assertEqual(0);
    });

    it('listenerRemovingItselfDuringNotify_doesNotSkipOthers', 0, () => {
      const seen: string[] = [];
      const first: ResultListener = () => {
        seen.push('first');
        core.offResult(KEY, first);
      };
      const second: ResultListener = () => {
        seen.push('second');
      };
      core.onResult(KEY, first);
      core.onResult(KEY, second);
      core.setResult(KEY, 1);
      expect(seen.join(',')).assertEqual('first,second');
      expect(core.listenerCount(KEY)).assertEqual(1);
    });

    it('push_forwardsNameAndParam', 0, () => {
      core.push('EditGoalRM', 8000);
      expect(stack.calls.join(',')).assertEqual('push:EditGoalRM:8000');
    });
  });
}
