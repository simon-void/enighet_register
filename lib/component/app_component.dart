import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:enighet_register/component/examees_component.dart';
import 'package:enighet_register/component/edit_examee_component.dart';
import 'package:enighet_register/component/view_examee_component.dart';
import 'package:enighet_register/component/occasions_component.dart';
import 'package:enighet_register/component/edit_occasion_component.dart';
import 'package:enighet_register/component/view_occasion_component.dart';
import 'package:enighet_register/component/status_component.dart';
import 'package:enighet_register/service/data_service.dart';

@Component(
    selector: 'aikido-register',
    template: '''
      <div class="header">
        <h1>{{title}}</h1>
        <nav>
          <!--a [routerLink]="['Status']">Status</a-->
          <a [routerLink]="['Examinees']">Graderade</a>
          <a [routerLink]="['Examina']">Examina</a>
        </nav>
      </div>
      <router-outlet></router-outlet>''',
    styleUrls: const ['tmpl/app_component.css'],
    directives: const [ROUTER_DIRECTIVES],
    providers: const [ROUTER_PROVIDERS, DataService])
@RouteConfig(const [
  const Route(path: '/status', name: 'Status', component: StatusComponent, useAsDefault: false),
  const Route(path: '/examinees', name: 'Examinees', component: ExameesComponent, useAsDefault: false),
  const Route(path: '/editExamee/:id', name: 'EditExamee', component: EditExameeComponent),
  const Route(path: '/viewExamee/:id', name: 'ViewExamee', component: ViewExameeComponent),
  const Route(path: '/occasions', name: 'Examina', component: OccasionsComponent, useAsDefault: true),
  const Route(path: '/editOccasion/:id', name: 'EditOccasion', component: EditOccasionComponent),
  const Route(path: '/viewOccasion/:id', name: 'ViewOccasion', component: ViewOccasionComponent),
])
class AppComponent {
  String title = "Enighets Graderingsregister Demo (no backend, paging or export)";
}
