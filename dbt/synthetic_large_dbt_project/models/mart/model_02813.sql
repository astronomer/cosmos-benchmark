{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02182') }},
        {{ ref('model_01834') }}
)
select id, 'model_02813' as name from sources
