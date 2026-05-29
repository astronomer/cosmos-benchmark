{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02041') }},
        {{ ref('model_01505') }},
        {{ ref('model_01767') }}
)
select id, 'model_02944' as name from sources
