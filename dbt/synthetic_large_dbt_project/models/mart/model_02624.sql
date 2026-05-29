{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01511') }},
        {{ ref('model_01805') }},
        {{ ref('model_01767') }}
)
select id, 'model_02624' as name from sources
