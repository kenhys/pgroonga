#pragma once

#include <postgres.h>

bool PGrnIsNoneValue(const char *value);
bool PGrnIsExplicitNoneValue(const char *value);
