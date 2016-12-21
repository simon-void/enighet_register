import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:enighet_register/component/examinees_component.dart';
import 'package:enighet_register/component/edit_examinee_component.dart';
import 'package:enighet_register/component/view_examinee_component.dart';
import 'package:enighet_register/component/occasions_component.dart';
import 'package:enighet_register/component/edit_occasion_component.dart';
import 'package:enighet_register/component/view_occasion_component.dart';
import 'package:enighet_register/component/status_component.dart';
import 'package:enighet_register/service/data_service.dart';
import 'package:enighet_register/service/local_data_service.dart';
import 'package:enighet_register/service/nav_service.dart';
import 'package:pikaday_datepicker/pikaday_datepicker.dart';

@Component(
    selector: 'aikido-register',
    template: '''
      <div class="header">
        <h1>{{title}}</h1>
        <nav>
          <a [routerLink]="['Status']">Status</a>
          <a [routerLink]="['Examinees']">Graderade</a>
          <a [routerLink]="['Occasions']">Examina</a>
        </nav>
      </div>
      <router-outlet></router-outlet>''',
    styleUrls: const ['tmpl/css/app_component.css'],
    directives: const [ROUTER_DIRECTIVES, PikadayComponent],
    providers: const [ROUTER_PROVIDERS,
                      NavigationService,
                      const Provider(DataService, useClass: LocalDataService)])
@RouteConfig(const [
  const Route(path: '/status', name: 'Status', component: StatusComponent, useAsDefault: true),
  const Route(path: '/examinees', name: 'Examinees', component: ExamineesComponent, useAsDefault: false),
  const Route(path: '/editExaminee/:id', name: 'EditExaminee', component: EditExameeComponent),
  const Route(path: '/viewExainmee/:id', name: 'ViewExaminee', component: ViewExamineeComponent),
  const Route(path: '/occasions', name: 'Occasions', component: OccasionsComponent, useAsDefault: false),
  const Route(path: '/editOccasion/:id', name: 'EditOccasion', component: EditOccasionComponent),
  const Route(path: '/viewOccasion/:id', name: 'ViewOccasion', component: ViewOccasionComponent),
])
class AppComponent {
  String title = "Enighets Graderingsregister Demo (no backend, paging or export)";
}
