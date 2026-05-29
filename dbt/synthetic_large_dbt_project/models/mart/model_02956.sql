{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01682') }},
        {{ ref('model_01782') }},
        {{ ref('model_01839') }}
)
select id, 'model_02956' as name from sources
