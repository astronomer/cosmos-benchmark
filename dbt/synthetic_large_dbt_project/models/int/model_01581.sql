{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00922') }},
        {{ ref('model_01001') }},
        {{ ref('model_01300') }}
)
select id, 'model_01581' as name from sources
