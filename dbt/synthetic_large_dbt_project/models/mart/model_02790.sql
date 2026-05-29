{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01764') }},
        {{ ref('model_02090') }}
)
select id, 'model_02790' as name from sources
