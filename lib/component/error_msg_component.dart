import 'package:angular2/core.dart';

@Component(
    selector: 'error',
    template: '''
      <div *ngIf="msg!=null">
        <span>
          {{msg}}
        </span>
      </div>''',
    styles: const ['''
      div {
        margin: 10px 0px 10px 0px;
      }
      span {
        background-color: #cc6666;
        color: white;
        padding: 5px;
        border-radius: 4px;
      }
    ''']
)
class ErrorMsgComponent {
  // the errormessage to show
  @Input() String msg;
}