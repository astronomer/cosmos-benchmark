{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02111') }},
        {{ ref('model_02214') }}
)
select id, 'model_02270' as name from sources
