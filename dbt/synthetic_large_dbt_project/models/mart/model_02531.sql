{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01767') }},
        {{ ref('model_01611') }},
        {{ ref('model_01622') }}
)
select id, 'model_02531' as name from sources
