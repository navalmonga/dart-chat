abstract class View {
  // run when loaded
  void onEnter();
  // run when exiting
  void onExit();
  // prepare template
  void prepare();
  // render view
  void render();
}
