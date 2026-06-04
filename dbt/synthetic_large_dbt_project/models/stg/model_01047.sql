{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00689') }},
        {{ ref('model_00522') }}
)
select id, 'model_01047' as name from sources
