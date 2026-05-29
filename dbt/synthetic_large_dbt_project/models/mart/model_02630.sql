{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01682') }},
        {{ ref('model_01834') }}
)
select id, 'model_02630' as name from sources
