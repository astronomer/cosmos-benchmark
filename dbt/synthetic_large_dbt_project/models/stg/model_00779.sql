{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00422') }},
        {{ ref('model_00717') }},
        {{ ref('model_00381') }}
)
select id, 'model_00779' as name from sources
