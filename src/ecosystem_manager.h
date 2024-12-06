#ifndef ECOSYSTEM_MANAGER_H
#define ECOSYSTEM_MANAGER_H

#include <godot_cpp/classes/sprite2d.hpp>

namespace godot
{

	class EcosystemManager : public Sprite2D
	{
		GDCLASS(EcosystemManager, Sprite2D)

	private:
		double test_var;

	protected:
		static void _bind_methods();

	public:
		EcosystemManager();
		~EcosystemManager();

		void _process(double delta) override;
	};

}

#endif // ECOSYSTEM_MANAGER_H