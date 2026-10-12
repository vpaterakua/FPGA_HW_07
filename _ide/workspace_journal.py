# 2026-10-12T21:16:17.771919800
import vitis

client = vitis.create_client()
client.set_workspace(path="Homework_007")

comp = client.get_component(name="max_slope")
comp.run(operation="C_SIMULATION")

cfg = client.get_config_file(path="/d:/Learn/robotdreams/Homework_007/max_slope/hls_config.cfg")

cfg.set_value(section="hls", key="syn.compile.pipeline_loops", value="0")

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

vitis.dispose()

