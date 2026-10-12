# 2026-10-11T20:09:05.091168100
import vitis

client = vitis.create_client()
client.set_workspace(path="Homework_007")

comp = client.create_hls_component(name = "max_slope",part = "xc7z010clg400-2",cfg_file = ["hls_config.cfg"],template = "empty_hls_component")

cfg = client.get_config_file(path="D:\Learn\robotdreams\Homework_007\max_slope\hls_config.cfg")

cfg.set_values(key="tb.file", values=["tb_moving_max.cpp"])

comp = client.get_component(name="max_slope")
comp.run(operation="C_SIMULATION")

cfg.set_values(key="syn.file", values=["../../FPGA-main/lesson_15/HW/moving_max.cpp"])

cfg.set_values(key="syn.blackbox.file", values=[])

cfg.set_values(key="syn.file", values=["../../FPGA-main/lesson_15/HW/moving_max.cpp", "moving_max.h"])

cfg.set_values(key="syn.file", values=["moving_max.h"])

cfg.set_values(key="syn.blackbox.file", values=[])

cfg.set_values(key="syn.file", values=["moving_max.h", "moving_max.cpp"])

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

vitis.dispose()

