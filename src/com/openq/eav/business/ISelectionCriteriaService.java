package com.openq.eav.business;

import java.util.List;
import java.util.Map;

import com.openq.eav.metadata.AttributeType;

public interface ISelectionCriteriaService {

    public List getSelectionCriteria(AttributeType[] basicAttributes, Map attrValueMap, boolean isNameKey);
}
