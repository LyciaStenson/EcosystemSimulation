#include "ecosystem_manager.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void EcosystemManager::_bind_methods()
{
    
}

EcosystemManager::EcosystemManager()
{
	test_var = 0.0;
}

EcosystemManager::~EcosystemManager()
{

}

void EcosystemManager::_process(double delta)
{
	test_var += delta;
}