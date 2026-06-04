{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00152') }},
        {{ ref('model_00668') }}
)
select id, 'model_01271' as name from sources
