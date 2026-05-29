{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00591') }},
        {{ ref('model_00666') }}
)
select id, 'model_00818' as name from sources
