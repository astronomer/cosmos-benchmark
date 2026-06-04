{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00646') }},
        {{ ref('model_00324') }}
)
select id, 'model_01446' as name from sources
