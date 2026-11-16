export interface StackLike {
  push(name: string, param?: Object): void;
  pop(): void;
  popToName(name: string): void;
}

export type ResultListener = (value: Object) => void;

export class RouteCore {
  private navigator: StackLike;
  private results: Map<string, Object> = new Map<string, Object>();
  private listeners: Map<string, ResultListener[]> = new Map<string, ResultListener[]>();

  constructor(stack: StackLike) {
    this.navigator = stack;
  }

  push(name: string, param?: Object): void {
    this.navigator.push(name, param);
  }

  back(key?: string, result?: Object): void {
    if (key !== undefined && result !== undefined) {
      this.setResult(key, result);
    }
    this.navigator.pop();
  }

  backTo(name: string, key?: string, result?: Object): void {
    if (key !== undefined && result !== undefined) {
      this.setResult(key, result);
    }
    this.navigator.popToName(name);
  }

  setResult(key: string, value: Object): void {
    this.results.set(key, value);
    const list = this.listeners.get(key);
    if (list !== undefined) {
      list.slice().forEach((cb: ResultListener) => cb(value));
    }
  }

  getResult(key: string): Object | undefined {
    return this.results.get(key);
  }

  onResult(key: string, cb: ResultListener): void {
    const list = this.listeners.get(key) ?? [];
    list.push(cb);
    this.listeners.set(key, list);
  }

  offResult(key: string, cb: ResultListener): void {
    const list = this.listeners.get(key);
    if (list === undefined) {
      return;
    }
    const remaining = list.filter((l: ResultListener) => l !== cb);
    if (remaining.length === 0) {
      this.listeners.delete(key);
    } else {
      this.listeners.set(key, remaining);
    }
  }

  listenerCount(key: string): number {
    return this.listeners.get(key)?.length ?? 0;
  }
}
