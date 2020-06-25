
import 'world.dart';
import 'platform.dart';

extension WorldPlatformCollision on World {

  CollisionAndFallDistance calculatePlayerCollisionsAndFallDistance(
      double playerDownSpeed) {
    final possibleCollisionStack = List();

    // find possible colliding platforms from lowest platform upwards stopping at players y position
    for(final platform in platforms) {
      if(platform.position.y > player.y) break;

      if(platform.isHOverlapping(player)) {
        possibleCollisionStack.add(platform);
      }
    }

    // check for first collision from highest platform to lowest
    for(final platform in possibleCollisionStack.reversed) {
      final distance = platform.distanceTo(player);
      if (distance - playerDownSpeed <= 0) {
        return CollisionAndFallDistance(distance, platform);
      }
    }

    return CollisionAndFallDistance(playerDownSpeed);
  }
}

class CollisionAndFallDistance {
  final PlatformInstance collidedPlatform;
  final double fallDistance;

  CollisionAndFallDistance(this.fallDistance, [this.collidedPlatform]);

  bool get hasCollision => collidedPlatform != null;
}
