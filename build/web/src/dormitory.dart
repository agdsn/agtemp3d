part of agscreen;

final wu5 = new WuDormitory("Wu5", 0, 0, 0);
final wu3 = new WuDormitory("Wu3", 100, 0, -50);
final wu1 = new WuDormitory("Wu1", -125, 0, -250);
final wu7 = new WuDormitory("Wu7", -100, 0, 50);
final wu9 = new WuDormitory("Wu9", 100, 0, 150);
final wu11 = new WuDormitory("Wu11", 0, 0, 250);
   
final zw41d = new ZwDormitory("41d", 225, 0, 25);
final zw41c = new ZwDormitory("41c", 325, 0, 25);
final zw41b = new ZwDormitory("41b", 425, 0, 25);
final zw41a = new ZwDormitory("41a", 525, 0, 25);
final zw41 = new ZwDormitory("41", 625, 0, 150);

final List<Dormitory> dormitories = [wu5, wu3, wu1, wu7, wu9, wu11,
                                     zw41d, zw41c, zw41b, zw41a, zw41];

abstract class Dormitory {
  final String name;
  final int w, h, d, lx, ly, lz;
  
  static final Material defaultMat =
      new LineBasicMaterial(color: 0xFFFFFF, opacity: 0.3);
  
  static final Material defaultWholeMaterial =
      new MeshBasicMaterial(wireframe: true, color: 0xFFFFFF,
          wireframeLinewidth: 3); 
  
  Vector3 getRoomPosition(int level, int x, int z){
    return new Vector3(lx + x * 10.0, ly + level * 10.0, lz + z * 10.0);
  }
  
  Dormitory(this.name, this.lx, this.ly, this.lz, this.w, this.h, this.d){
    for(int x = 0; x <= w; x++){
      for(int z = 0; z <= d; z++){
        final g = new Geometry();
        g.vertices.add(new Vector3(lx + x * 10.0, ly + 0.0, lz + z * 10.0));
        g.vertices.add(new Vector3(lx + x * 10.0, ly + h * 10.0, lz + z * 10.0));
        scene.add(new Line(g, defaultMat));
      }
      for(int y = 0; y <= h; y++){
        final g = new Geometry(); 
        g.vertices.add(new Vector3(lx + x * 10.0, ly + y * 10.0, lz + 0.0));
        g.vertices.add(new Vector3(lx + x * 10.0, ly + y * 10.0, lz + 10.0 * d));
        scene.add(new Line(g, defaultMat));
      }
    }
    for(int z = 0; z <= d; z++){
      for(int y = 0; y <= h; y++){
        final g = new Geometry();
        g.vertices.add(new Vector3(lx + 0.0, ly + y * 10.0, lz + 10.0 * z));
        g.vertices.add(new Vector3(lx + 10.0 * w, ly + y * 10.0, lz + 10.0 * z));
        scene.add(new Line(g, defaultMat));
      }
    }
    
    final Mesh cubeWhole = new Mesh(new CubeGeometry(10.0 * w, 10.0 * h, 10.0 * d), defaultWholeMaterial);
    cubeWhole.position..x = lx + 10.0 * w / 2
        ..y = ly + 10.0 * h / 2
        ..z = lz + 10.0 * d / 2;
    scene.add(cubeWhole);
  }
}

class WuDormitory extends Dormitory {
  WuDormitory(String name, int lx, int ly, int lz): super(name, lx, ly, lz, 4, 16, 4);
}

class ZwDormitory extends Dormitory { 
  ZwDormitory(String name, int lx, int ly, int lz): super(name, lx, ly, lz, 2, 4, 13);
}