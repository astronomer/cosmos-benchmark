{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00099') }},
        {{ ref('model_00467') }}
)
select id, 'model_01285' as name from sources
