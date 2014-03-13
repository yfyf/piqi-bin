PIQI?=$(shell which piqi)

PRIV_DIR=priv
LOCAL_PIQI_PATH=$(PRIV_DIR)/piqi

get_piqi: $(LOCAL_PIQI_PATH)

$(LOCAL_PIQI_PATH): $(PIQI) | $(PRIV_DIR)
	cp $(PIQI) $@

remove_piqi:
	rm $(LOCAL_PIQI_PATH)
