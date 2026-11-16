import { ComponentContent } from '@kit.ArkUI';
import { Palette } from '../../common/Constants';

export class ArcHeaderParams {
  title: string;

  constructor(title: string) {
    this.title = title;
  }
}

@Builder
function arcHeaderBuilder(params: ArcHeaderParams) {
  Text(params.title)
    .fontSize(15)
    .fontWeight(FontWeight.Bold)
    .fontColor(Palette.TEXT)
}

export function createArcHeader(uiContext: UIContext, title: string): ComponentContent<ArcHeaderParams> {
  return new ComponentContent(uiContext, wrapBuilder(arcHeaderBuilder), new ArcHeaderParams(title));
}
