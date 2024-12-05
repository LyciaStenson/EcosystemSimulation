#ifndef ECOSYSTEM_MANAGER_H
#define ECOSYSTEM_MANAGER_H

#include <godot_cpp/classes/navigation_region3d.hpp>

namespace godot {

class EcosystemManager : public NavigationRegion3D {
protected:
    static void _bind_methods();

public:
    EcosystemManager();
    ~EcosystemManager();
    
    void _process(double delta) override;
};

}

#endif // ECOSYSTEM_MANAGER_H