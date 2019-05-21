import './views/view.dart';

typedef ViewInstantiateFn = View Function(Map data);

class Router {
  Router() : _routes = [];
  List<Map<String, ViewInstantiateFn>> _routes;
  register(String path, ViewInstantiateFn viewInstance) {
    _routes.add({path: viewInstance});
  }
  go(String path, {Map params = null}) {
    _routes.firstWhere(
      (Map<String, ViewInstantiateFn> route) =>
        route.containsKey(path),
      orElse: () => null,
    ) [path](params ?? {});
  }
}
Router router = Router();
