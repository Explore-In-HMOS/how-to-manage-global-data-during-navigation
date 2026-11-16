import localUnitTest from './LocalUnit.test';
import routeCoreTest from './RouteCore.test';

export default function testsuite() {
  localUnitTest();
  routeCoreTest();
}
