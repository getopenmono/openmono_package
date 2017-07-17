include $(MONO_PATH)/Build.mk

paths:
	@echo "GCC: $(ARCH)";
	@echo "Monoprog: $(MONOPROG)";
	@echo "Mono Framework: $(MONO_FRAMEWORK_PATH)";
	@echo "Build dir: $(BUILD_DIR)";
	@echo "Include dir: $(INCLUDE_DIR)";
	@echo "$(TARGET_OBJECTS)";